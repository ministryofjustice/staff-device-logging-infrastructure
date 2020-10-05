# Sending new logs to OST

New logs can be sent to the OST Elastic Search cluster in one of two ways:

### 1. CloudWatch Log Subscriptions

The FunctionBeat shippers subscribe to [log groups in the same AWS account](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/Subscriptions.html) that they run in. 

They also subscribe to and ship logs from [cross-account logs](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/CrossAccountSubscriptions.html).

CloudWatch is where the majority of log data is sent to before being shipped.

The cross account subscriptions are used to ship logs from the Shared Services AWS account where the build pipelines are run, this also includes all CloudTrail logs.

Cross-account log subscriptions need to be backed by [Kinesis](https://aws.amazon.com/kinesis/), as this is the only supported log data recipient. The shippers subscribe to this Kinesis stream.

Same account log subscriptions are managed in Terraform, and adding a new log group from the same AWS account can be done by adding it to the variable called `log_groups` for the `functionbeat` module in the [main.tf](../main.tf) file.

Cross account log subscriptions are managed in the Shared Services Terraform code [repository](https://github.com/ministryofjustice/pttp-shared-services-infrastructure/tree/master/modules/log-forwarding).

Given the service ships log groups not created by this Terraform repo, not all log group names can be derived dynamically from Terraform resources. All CloudTrail logs in the AWS account are forwarded to CloudWatch, and then shipped.

### 2. Custom Logging API

For any logs not contained in CloudWatch, there is a REST endpoint that accepts logs via a POST request. These logs are then put onto an SQS queue, where they will be picked up by the shippers.

This endpoint should only be used if it is not possible to write logs into CloudWatch. 

*To add a new client to API Gateway, follow these steps:*

1. Add a new usage plan and API key resource to Terraform in the `custom_logging_api` module

2. Merge this into the master branch and push it through the build pipeline

3. Log into the production AWS console and get the API key from the API Gateway service.

4. Share the endpoint and API key with the new client
