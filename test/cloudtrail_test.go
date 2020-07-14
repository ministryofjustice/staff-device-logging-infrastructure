package test

import (
	"fmt"
	"os"
	"strings"
	"testing"
	"time"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/cloudwatchlogs"
	"github.com/aws/aws-sdk-go/service/s3"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
	"github.com/stretchr/testify/assert"
)

const cloudTrailTestRegion = "eu-west-2"
const cloudTrailTestRetryDelay = time.Second * 30
const cloudTrailTestMaxRetries = 30 // 15 minutes max timeout

func TestCloudTrailEventsAppearInCloudWatch(t *testing.T) {
	test := SetUpTestCloudTrailTests(t)

	randomID := strings.ToLower(random.UniqueId())
	bucketName := fmt.Sprintf("terratest-s3-bucket-%v", randomID)

	defer CleaningUpUntilTheEndOfCloudTrailTests(test, bucketName)
	SpinUpTheModuleForCloudTrailTests(test)

	CreateAResourceThatGeneratesACloudTrailEvent(bucketName)
	VerifyThatAMessageAppearedInACloudWatchLogGroup(test)
}

func CreateAResourceThatGeneratesACloudTrailEvent(bucketName string) {
	sess, err := session.NewSession(&aws.Config{
		Region: aws.String(cloudTrailTestRegion)},
	)

	svc := s3.New(sess)

	_, err = svc.CreateBucket(&s3.CreateBucketInput{
		Bucket: aws.String(bucketName),
	})
	if err != nil {
		exitErrorf("Unable to create bucket %q, %v", bucketName, err)
	}

	fmt.Printf("Waiting for bucket %q to be created...\n", bucketName)

	err = svc.WaitUntilBucketExists(&s3.HeadBucketInput{
		Bucket: aws.String(bucketName),
	})
}

func VerifyThatAMessageAppearedInACloudWatchLogGroup(thisTest testInfo) {
	accountNumber := terraform.Output(thisTest.instance, thisTest.config, "aws_account_number")
	logStream := accountNumber + "_CloudTrail_" + cloudTrailTestRegion
	logGroup := terraform.Output(thisTest.instance, thisTest.config, "log_group_name")

	sess, _ := session.NewSession(&aws.Config{Region: aws.String(cloudTrailTestRegion)})

	svc := cloudwatchlogs.New(sess)

	messagesReceived := false
	for i := 0; i <= cloudTrailTestMaxRetries; i++ {

		resp, err := svc.GetLogEvents(&cloudwatchlogs.GetLogEventsInput{
			Limit:         aws.Int64(100),
			LogGroupName:  aws.String(logGroup),
			LogStreamName: aws.String(logStream),
		})

		assert.NoError(thisTest.instance, err)

		eventsLength := len(resp.Events)

		if eventsLength > 0 {
			fmt.Printf("Received %v CloudWatch events from Cloudtrail\n", eventsLength)
			messagesReceived = true
			break
		}

		time.Sleep(cloudTrailTestRetryDelay)
	}

	assert.True(thisTest.instance, messagesReceived, "***Received no CloudWatch log messages from CloudTrail***")
}

func SetUpTestCloudTrailTests(t *testing.T) testInfo {
	t.Parallel()

	uniqueID := strings.ToLower(random.UniqueId())
	prefix := fmt.Sprintf("terratest-%v", uniqueID)

	rootFolder := ".."
	terraformFolderRelativeToRoot := "modules/cloudtrail"

	// This is required to run the same example in parallel
	tempTestFolder := test_structure.CopyTerraformFolderToTemp(t, rootFolder, terraformFolderRelativeToRoot)

	emptyMap := map[string]string{}

	return testInfo{
		instance: t,
		config: &terraform.Options{
			TerraformDir: tempTestFolder,
			Vars: map[string]interface{}{
				"prefix": prefix,
				"region": cloudTrailTestRegion,
				"tags":   emptyMap,
				"enable_cloudtrail_log_shipping_to_cloudwatch": true},
		},
	}
}

func SpinUpTheModuleForCloudTrailTests(test testInfo) {
	terraform.InitAndApply(test.instance, test.config)
}

func CleaningUpUntilTheEndOfCloudTrailTests(test testInfo, bucketName string) {
	terraform.Destroy(test.instance, test.config)

	sess, err := session.NewSession(&aws.Config{
		Region: aws.String(cloudTrailTestRegion)},
	)

	svc := s3.New(sess)

	_, err = svc.DeleteBucket(&s3.DeleteBucketInput{
		Bucket: aws.String(bucketName),
	})
	if err != nil {
		exitErrorf("Unable to delete bucket %q, %v", bucketName, err)
	}

	fmt.Printf("Waiting for bucket %q to be deleted...\n", bucketName)

	err = svc.WaitUntilBucketNotExists(&s3.HeadBucketInput{
		Bucket: aws.String(bucketName),
	})
}

func exitErrorf(msg string, args ...interface{}) {
	fmt.Fprintf(os.Stderr, msg+"\n", args...)
	os.Exit(1)
}
