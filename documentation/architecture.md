
# Architecture

This architecture acts as a forwarding proxy, and never stores data in the AWS account for longer than a configured period. (Currently 7 days).

This service is designed to adhere to the [AWS Well-Architected guidance](https://aws.amazon.com/architecture/well-architected/?wa-lens-whitepapers.sort-by=item.additionalFields.sortDate&wa-lens-whitepapers.sort-order=desc).

There are 5 aspects (referred to as pillars) that make up this definition:

  1. Operational Excellence 
  2. Security
  3. Reliability
  4. Performance Efficiency
  5. Cost Optimization

![architecture](diagrams/architecture.png)
[Image Source](diagrams/architecture.drawio)
