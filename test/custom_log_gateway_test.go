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
const testRegion = "eu-west-2"

func TestLogCanBeReadFromQueue(t *testing.T) {
	config := SetUpTest(t)

	defer CleaningUpAtTheEnd(t, config)
	SpinUpTheModule(t, config)

	WriteAMessageToTheApiAndExpect(t, config,
		200, withCorrectApiKey(t, config),
	)

	VerifyThatMessageWasPlacedOnQueue(t, config)
}

func TestLogCanBeSubmittedToAPIWithCorrectKey(t *testing.T) {
	config := SetUpTest(t)
	defer CleaningUpAtTheEnd(t, config)
	SpinUpTheModule(t, config)

	WriteAMessageToTheApiAndExpect(t, config,
		200, withCorrectApiKey(t, config),
	)
}

func TestLogCannotBeSubmittedToApiWithoutApiKey(t *testing.T) {
	config := SetUpTest(t)
	defer CleaningUpAtTheEnd(t, config)
	SpinUpTheModule(t, config)

	WriteAMessageToTheApiAndExpect(t, config,
		403, "",
	)
}

func TestThatQueueHasServerSideEncryptionEnabled(t *testing.T) {
	config := SetUpTest(t)
	defer CleaningUpAtTheEnd(t, config)
	SpinUpTheModule(t, config)

	VerifyThatQueueEncryptionIsEnabled(t, config)
}

func SpinUpTheModule(t *testing.T, config *terraform.Options) {
	terraform.InitAndApplyAndIdempotent(t, config)
}

func CleaningUpAtTheEnd(t *testing.T, config *terraform.Options) {
	terraform.Destroy(t, config)
}

func VerifyThatMessageWasPlacedOnQueue(t *testing.T, config *terraform.Options) {
	queueUrl := terraform.Output(t, config, "custom_log_queue_url")

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

	assert.NoError(t, err)
	assert.Len(t, result.Messages, 1, "***Received no messages***")

	expectedMessageBodyBytes, _ := json.Marshal(map[string]string{
		"foo": "bar",
	})

	expectedMessageBody := string(expectedMessageBodyBytes)

	messageBody := reformatJsonString(t, *result.Messages[0].Body)

	assert.Equal(t, expectedMessageBody, messageBody)
}

func VerifyThatQueueEncryptionIsEnabled(t *testing.T, config *terraform.Options) {
	sess, _ := session.NewSession(&aws.Config{Region: aws.String(testRegion)})

	sqsService := sqs.New(sess)

	queueUrl := terraform.Output(t, config, "custom_log_queue_url")

	kmsMasterKeyIdAttributeName := "KmsMasterKeyId"

	requiredQueueAttributeNames := []*string{&kmsMasterKeyIdAttributeName}

	queueAttributesInput := sqs.GetQueueAttributesInput{
		AttributeNames: requiredQueueAttributeNames,
		QueueUrl:       &queueUrl,
	}

	queueAttributes, _ := sqsService.GetQueueAttributes(&queueAttributesInput)

	if queueAttributes.Attributes[kmsMasterKeyIdAttributeName] == nil {
		t.Errorf("***Queue does not have encryption enabled***")
	}
}

func WriteAMessageToTheApiAndExpect(t *testing.T, config *terraform.Options, code int, apiKey string) {
	loggingEndpointPath := terraform.Output(t, config, "logging_endpoint_path")

	requestBody, _ := json.Marshal(map[string]string{
		"foo": "bar",
	})

	_, err := http_helper.HTTPDoWithRetryE(t,
		"POST",
		loggingEndpointPath,
		requestBody,
		map[string]string{"Content-Type": "application/json", "X-API-KEY": apiKey},
		code,
		10,
		retryDelay,
		nil,
	)

	assert.NoError(t, err, "***Api did not return code '%d'***", code)
}

func withCorrectApiKey(t *testing.T, config *terraform.Options) string {
	apiKey := terraform.Output(t, config, "custom_logging_api_key")
	return apiKey
}

func reformatJsonString(t *testing.T, theThing string) string {
	var messageBodyMap map[string]interface{}
	err := json.Unmarshal([]byte(theThing), &messageBodyMap)
	assert.NoError(t, err)

	messageBody, _ := json.Marshal(messageBodyMap)

	return string(messageBody)
}

func SetUpTest(t *testing.T) *terraform.Options {
	t.Parallel()

	uniqueId := random.UniqueId()
	prefix := fmt.Sprintf("terratest-%s", uniqueId)

	rootFolder := ".."
	terraformFolderRelativeToRoot := "modules/customLoggingApi"

	//this is required to run the same example in parallel
	tempTestFolder := test_structure.CopyTerraformFolderToTemp(t, rootFolder, terraformFolderRelativeToRoot)

	return &terraform.Options{
		TerraformDir: tempTestFolder,
		Vars:         map[string]interface{}{"prefix": prefix, "region": testRegion},
	}
}
