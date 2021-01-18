# Alarms

To ensure visibility on the health of the overall service, we have set up a Grafana dashboard for monitoring.  This dashboard also has alarms configured.

These alarms are triggered when certain thresholds are crossed on the following services:

- [Lambda](https://aws.amazon.com/lambda/)
- [Simple Queueing Service (SQS)](https://aws.amazon.com/sqs/)
- [Kinesis](https://aws.amazon.com/kinesis/)
- [API Gateway](https://docs.aws.amazon.com/apigateway/latest/developerguide/welcome.html)
- [Network Load Balancer](https://docs.aws.amazon.com/elasticloadbalancing/latest/network/load-balancer-cloudwatch-metrics.html)

Notifications are sent to a Slack Channel configured in Grafana.

The monitored [metrics](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/aws-services-cloudwatch-metrics.html) and thresholds are documented below:

---

### API Gateway

Please see API Gateway metrics [here](https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-metrics-and-dimensions.html).

**4XXError**

The number of client-side errors. 

*>= 10 over a time period of 1 minute*

**5XXError**

The number of server-side errors. 

*>= 10 over a time period of 1 minute*

**Count**

*=0 requests received from the Firewalls over a time period of 5 minutes*

**IntegrationLatency**

The time between when API Gateway relays a request to the backend (SQS) and when it receives a response from the backend (SQS).

*>= 1000ms over a time period of 1 minute*

**Latency**

The time between when API Gateway receives a request from a client and when it returns a response to the client. 

*>= 1000ms over a time period of 1 minute*

--- 

### Lambda

Please see Lambda metrics [here](https://docs.aws.amazon.com/lambda/latest/dg/monitoring-metrics.html).

**Errors**
The number of invocations that result in a function error.

*> 5 over a time period of 1 minute*

**Throttles**

The number of invocation requests that are throttled.

*> 1 over a time period of 2 minutes*

**ProvisionedConcurrencySpilloverInvocations**

The number of times your function code is executed on standard concurrency when all provisioned concurrency is in use.

*> 1 over a time period of 2 minutes*

--- 

### Simple Queueing Service (SQS log queue)

Please see SQS metrics [here](https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-available-cloudwatch-metrics.html).

**ApproximateNumberOfMessagesVisible**

The number of messages available for retrieval from the queue.

*> 1 over a time period of 1 minute*

**NumberOfMessagesSent**

The number of messages added to a queue.

*< 1 over a time period of 1 minute*

**NumberOfMessagesReceived**

The number of messages returned by calls to the ReceiveMessage action.

*< 1 over a time period of 1 minute*

--- 

### Network Load Balancer

Please see NLB metrics [here](https://docs.aws.amazon.com/elasticloadbalancing/latest/network/load-balancer-cloudwatch-metrics.html).

**UnHealthyHostCount**

The number of targets that are considered unhealthy. This is caused by either a failed health check or essential container process exit.

### Simple Queueing Service (Dead Letter Queue)

**NumberOfMessagesReceived**

The number of messages returned by calls to the ReceiveMessage action.

*> 1 over a time period of 1 minute*
