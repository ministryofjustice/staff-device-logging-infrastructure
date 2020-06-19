# Setup

## Step 1: Bootstrapping

Terraform state resides in an S3 bucket in the AWS account being provisioned.

Ensure that you have the following AWS profiles set up in ~/.aws/credentials

```
[pttp-development]
aws_access_key_id = your_key_id
aws_secret_access_key = your_secret_key

[pttp-pre-production]
aws_access_key_id = your_key_id
aws_secret_access_key = your_secret_key

[pttp-production]
aws_access_key_id = your_key_id
aws_secret_access_key = your_secret_key
```
`

To create the Terraform state bucket, run one of the following commands:

Note: Currently only Logging pipeline IAM roles are bootstrapped. Firewall roles are created 

### Development
`make bootstrap-development`

### Pre Production
`make bootstrap-pre-production`

### Production
`make bootstrap-production`

You'll be prompted for the environment name, which will be interpolated into the state file bucket name.

Please note that Makefile commands are meant to be used when running Terraform locally, and not when releasing through CI / CD.

## Step 2: Creating the cross account IAM roles

All updates to infrastructure in Development, Pre Production and Production are applied through through Terraform running on CodePipeline.
CodePipeline needs cross account IAM roles to exist on the target AWS accounts to allow Terraform to execute against them.


### Development
`make apply-development`

### Pre Production
`make apply-pre-production`

### Production
`make apply-production`

## Step 3: Setup CI / CD

Apply the PTTP [CI / CD Terraform](https://github.com/ministryofjustice/pttp-shared-services-infrastructure) to the Shared Services AWS account.
The trusted AWS account IAM roles will have been create up as a part of that, allowing CodePipeline to assume these cross account roles.

## Step 4: Release your new feature

Having set up your pipeline, you can now start releasing. 

