# Security

## Built in security by design

With security being one of the primary concerns of this service, it was designed to benefit from the following security measures:

- Not accessible from the public internet, reducing the potential attack vector significantly.

- Lambda is responsible for all compute, and the service inherits the security benefits of being fully serverless.

- The FunctionBeats shippers only use the following AWS services as log sources:

  1. AWS CloudWatch Logs
  2. Kinesis
  3. SQS

- [Security Groups](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-security-groups.html) have been added to the shippers to ensure EGRESS traffic can only be sent to trusted destinations (OST ElasticSearch cluster).

- [IAM roles and policies](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies.html) attached to the Lambdas ensure that only required API calls can be made within the AWS account.

- Infrastructure as code ensures that any changes to running services through the AWS console will be set back to a known state when pushed through the build pipeline.

- Encryption at rest and in transit prevents any unauthorised access to data temporarily kept within the service.

## Trusted Advisor

We use Trusted Advisor to automate and report on the following:

1. Cost optimisations
2. Performance
3. Security
4. Fault Tolerance
5. Service Limits

It can be used as a guide proactively address issues or improve the infrastructure.

## Data Protection Impact Assessment

No data in the AWS account should be kept for more than 7 days to be DPIA compliant. This service can be seen as a proxy to get logs into the OST ElasticSearch endpoint.

Logs are shipped as soon as they are delivered to CloudWatch, the retention period set on the log groups is for disaster recovery.

To ensure all logs have this retention policy set, we have a [script](../scripts/ensure_cloudwatch_log_retention_policies.sh) that iterates through all the CloudWatch logs in the AWS account and sets the retention policy of 7 days on each build going through the pipeline.
