resource "aws_ecs_task_definition" "server_task" {
  family                   = "${var.prefix}-server-task"
  task_role_arn            = aws_iam_role.ecs_execution_role.arn
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  network_mode             = "awsvpc"

  container_definitions = <<EOF
[
  {
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${aws_cloudwatch_log_group.server_log_group.name}",
        "awslogs-region": "eu-west-2",
        "awslogs-stream-prefix": "eu-west-2-docker-logs"
      }
    },
    "portMappings": [
      {
        "hostPort": 514,
        "containerPort": 514,
        "protocol": "udp"
      }
    ],
    "essential": true,
    "name": "syslog-server",
    "environment": [
      {
        "name": "CRITICAL_NOTIFICATIONS_ARN",
        "value": "${var.critical_notifications_arn}"
      }
    ],
    "image": "${aws_ecr_repository.docker_repository.repository_url}",
    "expanded": true
  }, {
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${aws_cloudwatch_log_group.server_log_group.name}",
        "awslogs-region": "eu-west-2",
        "awslogs-stream-prefix": "eu-west-2-docker-logs"
      }
    },
    "portMappings": [
      {
        "hostPort": 80,
        "protocol": "tcp",
        "containerPort": 80
      }
    ],
    "image": "nginx",
    "name": "NGINX"
  }
]
EOF
}
