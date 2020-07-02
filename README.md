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
- AWS account access to at least the `dev` and `shared services` accounts (ask in the channel `#moj-pttp` in Slack)

## Getting started

- `aws-vault add moj-pttp-dev` (this will prompt you for the values of your AWS Dev account)
- `aws-vault add moj-pttp-shared-services` (this will prompt you for the values of your AWS Shared Services account)
- `aws-vault exec moj-pttp-shared-services -- make init` (you will be prompted to bring across workspaces, say yes)
- `aws-vault exec moj-pttp-shared-services -- terraform workspace new <myname>`
- Create a `terraform.tfvars` in the root of the project and populate it with the values in examplevars, you can find a completed example of this in 1password7
- Edit your aws config (usually found in `.aws/config`) to include the key value pair of `region=eu-west-2`
- Check you are on your newly created workspace, (`aws-vault exec moj-pttp-shared-services -- terraform workspace list`) an asterisk should appear next to your current workspace
- Run `aws-vault exec moj-pttp-shared-services -- terraform plan` and check that for an output. If it appears as correct terraform output, run `aws-vault exec moj-pttp-shared-services -- terraform apply`.

## Useful commands

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
