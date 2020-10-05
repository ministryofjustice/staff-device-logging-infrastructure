# Getting Started

The Terraform that makes up this service is designed to be comprehensive and fully automated.

The current development flow is to run the Terraform from your own machine locally. Once the changes have tested, you can commit the changes to the `master` branch, where they will be automatically deployed through each of the various environments.

These environments include:

1. Development
2. Pre-production
3. Production

When running Terraform locally, you will be creating the infrastructure in the Development AWS environment.
Terraform is able to namespace your infrastructure by using [Terraform workspaces](https://www.terraform.io/docs/state/workspaces.html). Naming is managed through the [label](https://github.com/cloudposse/terraform-null-label) module in Terraform. The combination of these two tools will prevent name clashes with other developers and environments, allowing you to test your changes in isolation before committing them to the master branch.

To start developing on this service, follow the guidance below:

### Install required tools

- [AWS CLI](https://aws.amazon.com/cli/)
- [Aws Vault](https://github.com/99designs/aws-vault) 
- [tfenv](https://github.com/tfutils/tfenv)

### Authenticate with AWS

Terraform is run locally in a similar way to how it is run on the build pipelines.

It assumes an IAM role defined in the Shared Services, and target AWS accounts to gain access to the Development environment.
This is done in the Terraform AWS provider with the [assume_role](https://support.hashicorp.com/hc/en-us/articles/360041289933-Using-AWS-AssumeRole-with-the-AWS-Terraform-Provider) configuration.

You will authenticate with the Shared Services AWS account, which then will assume the role into the target account.

Assuming you have been given access to the Shared Services account, you can add it to AWS Vault:

Run: 

```sh
  aws-vault add moj-pttp-shared-services
```

Enter your IAM Access Key and Secret Access Key.

### Set up MFA on your AWS account

Multi-Factor Authentication (MFA) is required on AWS accounts in this project. You will need to do this for both your Dev and Shared Services AWS accounts.

The steps to set this up are as follows:

- Navigate to the AWS console for a given account.
- Click on "IAM" under Services in the AWS console.
- Click on "Users" in the IAM menu.
- Find your username within the list and click on it.
- Select the security credentials tab, then assign an MFA device using the "Virtual MFA device" option (follow the on-screen instructions for this step).
- Edit your local `~/.aws/config` file with the key value pair of `mfa_serial=<iam_role_from_mfa_device>` for each of your accounts. The value for `<iam_role_from_mfa_device>` can be found in the AWS console on your IAM user details page, under "Assigned MFA device". Ensure that you remove the text "(Virtual)" from the end of key value pair's value when you edit this file.

### Installing Terraform

tfenv is used to manage the versions of Terraform locally.
The current version of Terraform can be found in the `main.tf` file, install that version.

```sh
tfenv install 0.12.29
```

Use the newly installed version:

```sh
tfenv use 0.12.29
```

### terraform.tfvars

This file is used to set default local development variables, which Terraform depends on.

When creating infrastructure through the build pipeline, these variables are pulled from [SSM Parameter Store](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-parameter-store.html) and used by Terraform.

You can find an example of the variables file in SSM Parameter store in the Shared Services AWS account.

The name of the parameter is: `/staff-device/logging/terraform.tfvars`

### Applying your infrastructure

Run the following commands:

1. initialize your local Terraform state

```sh
aws-vault exec moj-pttp-shared-services -- make init
```

2. Create your Terraform workspace

```sh
aws-vault exec moj-pttp-shared-services -- terraform workspace new YOUR_UNIQUE_WORKSPACE_NAME
```

3. Ensure you are on the correct workspace

```sh
aws-vault exec moj-pttp-shared-services -- terraform workspace list
```

4. Apply your infrastructure

```sh
aws-vault exec moj-pttp-shared-services -- terraform apply
```

5. Destroying your infrastructure

```sh
aws-vault exec moj-pttp-shared-services -- terraform destroy
```
