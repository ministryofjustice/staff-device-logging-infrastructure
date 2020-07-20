package test

import (
	"encoding/json"
	"fmt"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/sqs"
	"github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
	"github.com/stretchr/testify/assert"
	"testing"
	"time"
)

const retryDelay = time.Second * 5
const retryCount = 20
const testRegion = "eu-west-2"

func TestLogCanBeReadFromQueue(t *testing.T) {
	test := SetUpTest(t)

	defer CleaningUpUntilTheEndOf(test)
	SpinUpTheModuleFor(test)

	WriteAMessageToTheApiAndExpect(200, withCorrectApiKeyFor(test), test)
	VerifyThatMessageWasPlacedOnQueue(test)
}

func TestLogCanBeSubmittedToAPIWithCorrectKey(t *testing.T) {
	test := SetUpTest(t)

	defer CleaningUpUntilTheEndOf(test)
	SpinUpTheModuleFor(test)

	WriteAMessageToTheApiAndExpect(200, withCorrectApiKeyFor(test), test)
}

func TestLogCannotBeSubmittedToApiWithoutApiKey(t *testing.T) {
	test := SetUpTest(t)

	defer CleaningUpUntilTheEndOf(test)
	SpinUpTheModuleFor(test)

	WriteAMessageToTheApiAndExpect(403, "", test)
}

func TestThatQueueHasServerSideEncryptionEnabled(t *testing.T) {
	thisTest := SetUpTest(t)

	defer CleaningUpUntilTheEndOf(thisTest)
	SpinUpTheModuleFor(thisTest)

	VerifyThatQueueEncryptionIsEnabled(thisTest)
}

func SpinUpTheModuleFor(test testInfo) {
	terraform.InitAndApply(test.instance, test.config)
}

func CleaningUpUntilTheEndOf(test testInfo) {
	terraform.Destroy(test.instance, test.config)
}

func VerifyThatMessageWasPlacedOnQueue(thisTest testInfo) {
	queueUrl := terraform.Output(thisTest.instance, thisTest.config, "custom_log_queue_url")

	sess, _ := session.NewSession(&aws.Config{Region: aws.String(testRegion)})

	sqsService := sqs.New(sess)

	result, err := sqsService.ReceiveMessage(&sqs.ReceiveMessageInput{
		AttributeNames: []*string{
			aws.String(sqs.MessageSystemAttributeNameSentTimestamp),
		},
		MessageAttributeNames: []*string{
			aws.String(sqs.QueueAttributeNameAll),
		},
		QueueUrl:            &queueUrl,
		MaxNumberOfMessages: aws.Int64(1),
		VisibilityTimeout:   aws.Int64(20), // 20 seconds
		WaitTimeSeconds:     aws.Int64(20),
	})

	assert.NoError(thisTest.instance, err)
	assert.Len(thisTest.instance, result.Messages, 1, "***Received no messages***")

	expectedMessageBodyBytes, _ := json.Marshal(map[string]string{
		"foo": "bar",
	})

	expectedMessageBody := string(expectedMessageBodyBytes)

	messageBody := reformatJsonString(*result.Messages[0].Body, thisTest)

	assert.Equal(thisTest.instance, expectedMessageBody, messageBody)
}

func VerifyThatQueueEncryptionIsEnabled(thisTest testInfo) {
	sess, _ := session.NewSession(&aws.Config{Region: aws.String(testRegion)})

	sqsService := sqs.New(sess)

	queueUrl := terraform.Output(thisTest.instance, thisTest.config, "custom_log_queue_url")

	kmsMasterKeyIdAttributeName := "KmsMasterKeyId"

	requiredQueueAttributeNames := []*string{&kmsMasterKeyIdAttributeName}

	queueAttributesInput := sqs.GetQueueAttributesInput{
		AttributeNames: requiredQueueAttributeNames,
		QueueUrl:       &queueUrl,
	}

	queueAttributes, _ := sqsService.GetQueueAttributes(&queueAttributesInput)

	if queueAttributes.Attributes[kmsMasterKeyIdAttributeName] == nil {
		thisTest.instance.Errorf("***Queue does not have encryption enabled***")
	}
}

func WriteAMessageToTheApiAndExpect(code int, apiKey string, thisTest testInfo) {
	loggingEndpointPath := terraform.Output(thisTest.instance, thisTest.config, "logging_endpoint_path")

	requestBody, _ := json.Marshal(map[string]string{
		"foo": "bar",
	})

	_, err := http_helper.HTTPDoWithRetryE(thisTest.instance,
		"POST",
		loggingEndpointPath,
		requestBody,
		map[string]string{"Content-Type": "application/json", "X-API-KEY": apiKey},
		code,
		retryCount,
		retryDelay,
		nil,
	)

	assert.NoError(thisTest.instance, err, "***Api did not return code '%d'***", code)
}

func withCorrectApiKeyFor(thisTest testInfo) string {
	apiKey := terraform.Output(thisTest.instance, thisTest.config, "custom_logging_api_key")
	return apiKey
}

func reformatJsonString(theThing string, thisTest testInfo) string {
	var messageBodyMap map[string]interface{}
	err := json.Unmarshal([]byte(theThing), &messageBodyMap)
	assert.NoError(thisTest.instance, err)

	messageBody, _ := json.Marshal(messageBodyMap)

	return string(messageBody)
}

func SetUpTest(t *testing.T) testInfo {
	t.Parallel()

	uniqueId := random.UniqueId()
	prefix := fmt.Sprintf("terratest-%s", uniqueId)

	rootFolder := ".."
	terraformFolderRelativeToRoot := "modules/custom_logging_api"

	//this is required to run the same example in parallel
	tempTestFolder := test_structure.CopyTerraformFolderToTemp(t, rootFolder, terraformFolderRelativeToRoot)

	return testInfo{
		instance: t,
		config: &terraform.Options{
			TerraformDir: tempTestFolder,
			Vars:         map[string]interface{}{"prefix": prefix, "region": testRegion},
		},
	}
}

type testInfo struct {
	instance *testing.T
	config   *terraform.Options
}
