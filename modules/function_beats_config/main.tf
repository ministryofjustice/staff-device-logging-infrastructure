locals {
  log_group_map_array = [
    for group in var.log_groups : {
      log_group_name : group
    }
  ]
  cloudwatch_name = "${var.prefix}-cloudwatch"
  sqs_name        = "${var.prefix}-sqs"
  kinesis_name    = "${var.prefix}-kinesis"

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
        dead_letter_config : {
          target_arn : var.beats_dead_letter_queue_arn
        },
        role : var.deploy_role_arn,
        tags: {
          data_source: "cloudwatch"
        },
        virtual_private_cloud : {
          security_group_ids : var.security_group_ids
          subnet_ids : var.subnet_ids
        },
        triggers : local.log_group_map_array,
        processors : [
          {
            add_tags : {
              tags: ["cloudwatch_logs"],
              target : "log_source"
            }
          }
        ]
      },
      {
        name : local.sqs_name,
        concurrency: 100,
        enabled : true,
        type : "sqs",
        description : "lambda function for SQS events",
        role : var.deploy_role_arn,
        tags: {
          data_source: "firewalls"
        },
        virtual_private_cloud : {
          security_group_ids : var.security_group_ids
          subnet_ids : var.subnet_ids
        },
        dead_letter_config : {
          target_arn : var.beats_dead_letter_queue_arn
        },
        triggers : [
          { event_source_arn : var.sqs_log_queue }
        ],
        processors : [
          {
            add_tags : {
              tags: ["sqs"],
              target : "log_source"
            }
          }
        ]
      },
      {
        name : local.kinesis_name,
        concurrency: 100,
        enabled : true,
        type : "cloudwatch_logs_kinesis",
        description : "lambda function for Kinesis stream",
        role : var.deploy_role_arn,
        tags: {
          data_source: "shared_services"
        },
        virtual_private_cloud : {
          security_group_ids : var.security_group_ids
          subnet_ids : var.subnet_ids
        },
        dead_letter_config : {
          target_arn : var.beats_dead_letter_queue_arn
        },
        triggers : [
          { event_source_arn : var.kinesis_stream_arn }
        ],
        processors : [
          {
            add_tags : {
              tags: ["kinesis"],
              target : "log_source"
            }
          }, {
            decode_json_fields : {
              fields : ["message"],
              process_array: true
            }
          }
        ]
      }
    ],
    "setup.template.settings" : {
      "index.number_of_shards" : 1
    }
    "setup.template.name" : "functionbeat"
    "setup.template.pattern" : "functionbeat-%%{[agent.version]}-*"
    "setup.ilm.enabled" : false
    "logging.level" : "warning"
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
      {
        add_tags : {
          tags: [var.prefix],
          target : "environment"
        }
      },
      { add_host_metadata : { } },
      { add_cloud_metadata : { "providers" : ["aws"] } }
    ]
  })
}

resource "local_file" "config" {
  filename          = "functionbeat-config.yml"
  file_permission   = "0600"
  sensitive_content = local.config
}
