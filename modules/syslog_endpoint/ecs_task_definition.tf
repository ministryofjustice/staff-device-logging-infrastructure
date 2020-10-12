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
    "portMappings": [
      {
        "hostPort": 80,
        "protocol": "tcp",
        "containerPort": 80
      }
    ],
    "image": "${aws_ecr_repository.docker_repository.repository_url}:health_check",
    "name": "NGINX"
  }
]
EOF
}
