package test

import (
	"encoding/json"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/sqs"
	"github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"log"
	"testing"
	"time"
)

var _t *testing.T
var _terraformOptions *terraform.Options
const retryDelay = time.Second * 5


func TestLogCanBeReadFromQueue(t *testing.T) {
	SetUpTest(t)

	SpinUpTheModule()
	defer CleaningUpAtTheEnd()
	WriteAMessageToTheApiAndExpect(200, withCorrectApiKey())
	VerifyThatMessageWasPlacedOnQueue()
}

func TestLogCanBeSubmittedToAPIWithCorrectKey(t *testing.T) {
	SetUpTest(t)

	SpinUpTheModule()
	defer CleaningUpAtTheEnd()
	WriteAMessageToTheApiAndExpect(200, withCorrectApiKey())
}

func TestLogCannotBeSubmittedToApiWithoutApiKey(t *testing.T) {
	SetUpTest(t)

	SpinUpTheModule()
	defer CleaningUpAtTheEnd()
	WriteAMessageToTheApiAndExpect(403, "")
}


func TestThatQueueHasServerSideEncryptionEnabled(t *testing.T) {
	SetUpTest(t)

	SpinUpTheModule()
	defer CleaningUpAtTheEnd()
	VerifyThatQueueEncryptionIsEnabled(t)
}


func SpinUpTheModule(){
	_terraformOptions = &terraform.Options{
		TerraformDir: "../modules/customLoggingApi",
		Vars:         map[string]interface{}{"prefix": "david-test", "region": "eu-west-2"},
	}

	terraform.InitAndApplyAndIdempotent(_t, _terraformOptions)
}

func CleaningUpAtTheEnd() string {
	return terraform.Destroy(_t, _terraformOptions)
}

func VerifyThatMessageWasPlacedOnQueue() {
	sess, _ := session.NewSession(&aws.Config{Region: aws.String("eu-west-2")})

	sqsService := sqs.New(sess)

	queueUrl := terraform.Output(_t, _terraformOptions, "custom_log_queue_url")

	result, err := sqsService.ReceiveMessage(&sqs.ReceiveMessageInput{
		AttributeNames: []*string{
			aws.String(sqs.MessageSystemAttributeNameSentTimestamp),
		},
		MessageAttributeNames: []*string{
			aws.String(sqs.QueueAttributeNameAll),
		},
		QueueUrl:            &queueUrl,
		MaxNumberOfMessages: aws.Int64(1),
		VisibilityTimeout:   aws.Int64(20),  // 20 seconds
		WaitTimeSeconds:     aws.Int64(0),
	})

	if err != nil {
		_t.Fatalf("***Error:***")
		_t.Fatalf(err.Error())
		_t.Fail()
		return
	}

	if len(result.Messages) == 0 {
		_t.Fatalf("***Received no messages***")
		_t.Fail()
		return
	}

	expectedMessageBodyBytes, _ := json.Marshal(map[string]string{
		"foo": "bar",
	})

	expectedMessageBody := string(expectedMessageBodyBytes)


	messageBody := reformatJsonString(*result.Messages[0].Body)


	if messageBody != expectedMessageBody {
		log.Println("***expected message***:")
		log.Println(expectedMessageBody)
		log.Println("***but got***:")
		log.Println(messageBody)
		_t.Fail()
	}
}

func VerifyThatQueueEncryptionIsEnabled(t *testing.T) {
	sess, _ := session.NewSession(&aws.Config{Region: aws.String("eu-west-2")})

	sqsService := sqs.New(sess)

	queueUrl := terraform.Output(_t, _terraformOptions, "custom_log_queue_url")

	kmsMasterKeyIdAttributeName := "KmsMasterKeyId"

	requiredQueueAttributeNames := []*string{&kmsMasterKeyIdAttributeName}

	queueAttributesInput := sqs.GetQueueAttributesInput{
		AttributeNames: requiredQueueAttributeNames,
		QueueUrl:       &queueUrl,
	}

	queueAttributes, _ := sqsService.GetQueueAttributes(&queueAttributesInput)

	if queueAttributes.Attributes[kmsMasterKeyIdAttributeName] == nil {
		t.Fatal("***Queue does not have encryption enabled***")
		t.Fail()
	}
}

func WriteAMessageToTheApiAndExpect(code int, apiKey string) {
	loggingEndpointPath := terraform.Output(_t, _terraformOptions, "logging_endpoint_path")

	requestBody, _ := json.Marshal(map[string]string{
		"foo": "bar",
	})

	_, err := http_helper.HTTPDoWithRetryE(_t,
		"POST",
		loggingEndpointPath,
		requestBody,
		map[string]string{"Content-Type": "application/json", "X-API-KEY": apiKey},
		code,
		5,
		retryDelay,
		nil,
	)

	if err != nil {
		_t.Fatalf("***Api did not return code '%d'***", code)
		_t.Fail()
	}
}

func withCorrectApiKey() string {
	apiKey := terraform.Output(_t, _terraformOptions, "custom_logging_api_key")
	return apiKey
}

func reformatJsonString(theThing string) string {
	var messageBodyMap map[string]interface{}
	err := json.Unmarshal([]byte(theThing), &messageBodyMap)

	if err != nil {
		log.Println("***Unable to reformat json***")
		log.Println(err.Error())
		log.Println(theThing)
	}

	messageBody, _ := json.Marshal(messageBodyMap)

	return string(messageBody)
}

func SetUpTest(t *testing.T) {
	_t = t
}
