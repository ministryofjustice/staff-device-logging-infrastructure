[![repo standards badge](https://img.shields.io/badge/dynamic/json?color=blue&style=flat&logo=github&labelColor=32393F&label=MoJ%20Compliant&query=%24.result&url=https%3A%2F%2Foperations-engineering-reports.cloud-platform.service.justice.gov.uk%2Fapi%2Fv1%2Fcompliant_public_repositories%2Fstaff-device-logging-infrastructure)](https://operations-engineering-reports.cloud-platform.service.justice.gov.uk/public-github-repositories.html#staff-device-logging-infrastructure "Link to report")

# Staff Device Logging Infrastructure

This is the Log Shipping infrastructure used by the [Ministry of Justice](https://www.gov.uk/government/organisations/ministry-of-justice) to forward logs to the Operational Security Team.

## Related Repositories

This repository defines the **system infrastructure only**. Specific components and applications are defined in their own logical external repositories.

- [Shared Services](https://github.com/ministryofjustice/staff-device-shared-services-infrastructure)
- [Syslog to Cloudwatch](https://github.com/ministryofjustice/staff-device-logging-syslog-to-cloudwatch)

Below you will find various documentation about managing and running this service:

- [Getting Started](./documentation/getting_started.md)
  
- [Alarms](./documentation/alarms.md)
  
- [Deployment](./documentation/deployment.md)
  
- [Disaster Recovery](./documentation/disaster_recovery.md)
  
- [Connecting to Remote Elastic Search Cluster](./documentation/connecting_to_remote_elastic_search_cluster.md)
  
- [Sending new logs to OST](./documentation/sending_new_logs_to_ost.md)
  
- [Secrets Management](./documentation/secrets_management.md)
  
- [Security](./documentation/security.md)
  
- [FunctionBeat](./documentation/functionbeat.md)

- [Performance Benchmarks](./documentation/performance_benchmarks.md)

- [Architecture](./documentation/architecture.md)

![architecture](./documentation/diagrams/architecture.png)

[Image Source](./documentation/diagrams/architecture.drawio)
