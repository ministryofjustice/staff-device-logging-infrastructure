package test

import (
	"fmt"
	"os"
	"strings"
	"testing"
	"time"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/s3"
    "github.com/aws/aws-sdk-go/service/cloudwatchlogs"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
)

const retryDelay2 = time.Second * 5
const testRegion2 = "eu-west-2"

func TestCloudTrailEventsAppearInCloudWatch(t *testing.T) {
	test := SetUpTest2(t)

	randomID := strings.ToLower(random.UniqueId())
	// fmt.Printf("%s", randomID)
	bucketName := fmt.Sprintf("terratest-s3-bucket-%v", randomID)

	defer CleaningUpUntilTheEndOf2(test, bucketName)
	SpinUpTheModuleFor2(test)

	CreateAnS3Bucket(bucketName)
	VerifyThatAMessageAppearedInACloudWatchLogGroup(test)
}

func CreateAnS3Bucket(bucketName string) {
	sess, err := session.NewSession(&aws.Config{
		Region: aws.String(testRegion2)},
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
	logStream := accountNumber + "_CloudTrail_" + testRegion2
	logGroup := terraform.Output(thisTest.instance, thisTest.config, "log_group_name")


	sess, _ := session.NewSession(&aws.Config{Region: aws.String(testRegion2)})

	svc := cloudwatchlogs.New(sess)

    resp, err := svc.GetLogEvents(&cloudwatchlogs.GetLogEventsInput{
        Limit:         aws.Int64(100),
        LogGroupName:  aws.String(logGroup),
        LogStreamName: aws.String(logStream),
    })

	assert.NoError(thisTest.instance, err)
	assert.Len(thisTest.instance, resp.Events, 200, "***No CloudWatch messages received***")
}

// TODO: either make test info globally scoped, or create a local version here
func SetUpTest2(t *testing.T) testInfo {
	t.Parallel()

	uniqueID := strings.ToLower(random.UniqueId())
	prefix := fmt.Sprintf("terratest-%v", uniqueID)

	rootFolder := ".."
	terraformFolderRelativeToRoot := "modules/cloudtrail"

	//this is required to run the same example in parallel
	tempTestFolder := test_structure.CopyTerraformFolderToTemp(t, rootFolder, terraformFolderRelativeToRoot)

	emptyMap := map[string]string{}

	return testInfo{
		instance: t,
		config: &terraform.Options{
			TerraformDir: tempTestFolder,
			Vars: map[string]interface{}{
				"prefix": prefix,
				"region": testRegion2,
				"tags":   emptyMap},
		},
	}
}

func SpinUpTheModuleFor2(test testInfo) {
	terraform.InitAndApply(test.instance, test.config)
}

func CleaningUpUntilTheEndOf2(test testInfo, bucketName string) {
	terraform.Destroy(test.instance, test.config)

	sess, err := session.NewSession(&aws.Config{
		Region: aws.String(testRegion2)},
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

// TODO: have a proper look at this
func exitErrorf(msg string, args ...interface{}) {
	fmt.Fprintf(os.Stderr, msg+"\n", args...)
	os.Exit(1)
}
