package test

import (
	"fmt"
	"time"

	"github.com/aws/aws-sdk-go/aws/credentials/stscreds"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/gruntwork-io/terratest/modules/terraform"

	"testing"
)

func xTestRoleAssumable(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		// Set the path to the Terraform code that will be tested.
		TerraformDir: "../examples/iam_role",
	}

	// Clean up resources with "terraform destroy" at the end of the test.
	defer terraform.Destroy(t, terraformOptions)

	// Run "terraform init" and "terraform apply". Fail the test if there are any errors.
	terraform.InitAndApplyAndIdempotent(t, terraformOptions)

	// Run `terraform output` to get the values of output variables and check they have the expected values.
	role_arn := terraform.Output(t, terraformOptions, "role_arn")

	time.Sleep(10 * time.Second) //we need to wait while iam rolls out this role

	sess := session.Must(session.NewSession())

	// Create the credentials from AssumeRoleProvider to assume the role
	// referenced by the "myRoleARN" ARN.
	creds := stscreds.NewCredentials(sess, role_arn)

	_, err := creds.Get()
	if err != nil {
		fmt.Println(err.Error())
		t.Fail()
	}
}
