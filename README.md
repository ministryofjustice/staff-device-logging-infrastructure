# Prison Technology Transformation Programme AWS Infrastructure

Prison Technology Transformation Programme (PTTP) is a Ministry of Justice (MoJ)

## Introduction

<!-- These maps to different accounts -->

The current environments are:

- Development
- Pre-production
- Production

<!-- Should this be in 2 seperate repos? -->

The Terraform in this repository serves 2 purposes:

<!-- is this really correct? -->

- Bootstrapping of Development, Pre-production and Production environments on AWS.

<!-- Can we flesh this out a bit? -->

- Creating the infrastructure for various services/solutions such as Logging and DNS / DHCP.

The Terraform in this repository can be run in 2 different contexts:

- Your own machine for bootstrapping AWS, or
- By releasing features through the CodePipeline in the shared Services Account.

## Pre-requisites

- [aws-vault](https://github.com/99designs/aws-vault) should be installed
- [Terraform](https://www.terraform.io/) should be installed (we recommend using a Terraform version manager such as [tfenv](https://github.com/tfutils/tfenv))
<!-- What about people who join the project who don't have access to this Slack channel? -->
- AWS account access to at least the `dev` and `shared services` accounts (ask in the channel `#moj-pttp` in Slack)

## Getting started

- `aws-vault add moj-pttp-dev` (this will prompt you for the values of your AWS Dev account)
- `aws-vault add moj-pttp-shared-services` (this will prompt you for the values of your AWS Shared Services account)
- `aws-vault exec moj-pttp-shared-services -- make init` (you will be prompted to bring across workspaces, say yes)
- `aws-vault exec moj-pttp-shared-services -- terraform workspace new <myname>` (replace `<myname>` with your own name)
- Run `aws-vault exec moj-pttp-shared-services -- terraform workspace list` and make sure that your new workspace with your name is selected
- If you don't see your new workspace selected, run `aws-vault exec moj-pttp-shared-services -- terraform workspace select <myname>`
- Create a `terraform.tfvars` in the root of the project and populate it with the values in examplevars, you can find a completed example of this in 1password7, in a vault named "PTTP". Make sure to change the field "owner_email" to your own email address
- Edit your aws config (usually found in `.aws/config`) to include the key value pair of `region=eu-west-2` for both the `profile moj-pttp-dev` and the `profile moj-pttp-shared-services` workspaces
- Run `aws-vault exec moj-pttp-shared-services -- terraform plan` and check that for an output. If it appears as correct terraform output, run `aws-vault exec moj-pttp-shared-services -- terraform apply`.

## Once you are done

- `aws-vault exec moj-pttp-shared-services -- terraform destroy` this will tear down the infrastructure in your workspace.

## Testing

There is a testing suite called Terratest that tests modules in this codebase
To run this codebase you will need to [install golang](https://formulae.brew.sh/formula/go)

To run the unit test run

- `cd test`
- `go test -v -timeout 30m`

## Modules

### CustomLoggingApi

This spins up an AWS API Gateway which is secured by an API key. JSON messages can be posted to the `/production/logs` endpoint
which will then be placed on an encrypted SQS queue to await further processing
