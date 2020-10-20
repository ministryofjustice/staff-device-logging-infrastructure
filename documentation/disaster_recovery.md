# Disaster Recovery

Any messages that cannot be shipped will be placed on a Dead letter SQS queue.

To process this dead letter queue, run `./scripts/process_dead_letter_queue` and follow the prompts.

## Misconfigured API Gateway Credentials

If the authentication credentials or endpoint was changed, it would prevent external services from communicating with API Gateway. [Alarms](./alarms.md) have been set to monitor what we consider the minimum amount of requests that we expect to be coming through the API Gateway.

Ensure that the endpoint and API keys are correct. The missing logs will need to be re-sent from the source service.

As a security precaution, all logs are stored in the AWS for a maximum 7 days. This is to be compliant with DPIA requirements. Logs are persisted in either CloudWatch or SQS for this duration.

The 2 most likely causes of failure that can arise are:

## Remote connection to destination OST service

If any configuration details changed on the remote ElasticSearch or on the shippers themselves, logs will be unable be shipped. Any logs not shipped will be put on a dead letter queue (DLQ).

[Alarms](./alarms.md) have been configured to monitor the size of this queue and to alert developers if it is greater than 0.

Once the cause of this failure has been identified and diagnosed, the queue can be processed to send the missing logs.
