# Connecting to remote ElasticSearch Cluster

The ElasticSearch cluster operated by the MoJ Operational Security Team (OST) is the final destination for all logs. It is here that the logs will be analysed and audited for any security risks.

**To establish a connection with the remote ElasticSearch cluster, follow these steps:**

1. Request the following details from the OST:

    - Destination URL (URL of the ElasticSearch cluster, this will resolve to a private IP address)
    - Destination Username 
    - Destination Password
    - Certificate Key
    - Certificate
    - CA Certificate
    - Target AWS Account ID
    - Target VPC ID
    - Target VPC CIDR block

2. These above values and certificates need to be present in SSM Parameter store, where they will be injected into Terraform as variables at runtime.

3. Set up a VPC peering connection with OST VPC in Terraform.
  This peering connection is only created when Terraform is run through the build pipelines, and is not created when run locally. The peering connection code can be found in the [vpc_peering module](../modules/vpc_peering/).

    **This module does two things:**

    - The Peering connection request which needs to be manually approved by the destination VPC / AWS account.
    - A route in our VPC route table pointing to the peering connection on a specific CIDR range.

4. Ensure logs are being sent over the peering connections. AWS CloudWatch logs, Lambda metrics and [alarms](./alarms.md) will indicate whether logs are being successfully shipped.
