locals {
  log_group_map_array = [
    for group in var.log_groups : {
      log_group_name : group
    }
  ]
  cloudwatch_name = "${var.prefix}-cloudwatch"
  sqs_name        = "${var.prefix}-sqs"

  config = yamlencode({
    "functionbeat.provider.aws.endpoint" : "s3.amazonaws.com"
    "functionbeat.provider.aws.deploy_bucket" : var.deploy_bucket


    "functionbeat.provider.aws.functions" : [
      {
        name : local.cloudwatch_name,
        concurrency: 100,
        enabled : true,
        type : "cloudwatch_logs",
        description : "lambda function for cloudwatch logs",
        role : var.deploy_role_arn,
        virtual_private_cloud : {
          security_group_ids : var.security_group_ids
          subnet_ids : var.subnet_ids
        },
        "dead_letter_config.target_arn" : var.beats_dead_letter_queue_arn
        triggers : local.log_group_map_array
      },
      {
        name : local.sqs_name,
        concurrency: 100,
        enabled : true,
        type : "sqs",
        description : "lambda function for SQS events",
        role : var.deploy_role_arn,
        virtual_private_cloud : {
          security_group_ids : var.security_group_ids
          subnet_ids : var.subnet_ids
        },
        "dead_letter_config.target_arn" : var.beats_dead_letter_queue_arn
        triggers : [
          { event_source_arn : var.sqs_log_queue }
        ]
      }
    ],
    "setup.template.settings" : {
      "index.number_of_shards" : 1
    }
    "setup.template.name" : "functionbeat"
    "setup.template.pattern" : "functionbeat-%%{[agent.version]}-*"
    "setup.ilm.enabled" : false

    "output.elasticsearch" : {
      hosts : [var.destination_url]
      protocol : "https"
      username : var.destination_username
      password : var.destination_password
      index : "functionbeat-%%{[agent.version]}-%%{+yyyy.MM.dd}"
    }
    "output.elasticsearch.ssl.certificate_authorities" : ["elk-ca.crt"]
    "output.elasticsearch.ssl.certificate" : "moj.crt"
    "output.elasticsearch.ssl.key" : "moj.key"

    processors : [
      { add_host_metadata : null },
      { add_cloud_metadata : { "providers" : ["aws"] } }
    ]
  })
}

resource "local_file" "config" {
  filename          = "functionbeat-config.yml"
  file_permission   = "0600"
  sensitive_content = local.config
}
