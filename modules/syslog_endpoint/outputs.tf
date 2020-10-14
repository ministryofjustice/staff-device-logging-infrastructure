output "ecr" {
  value = {
    repository_url = aws_ecr_repository.docker_repository.repository_url
    registry_id    = aws_ecr_repository.docker_repository.registry_id
    cluster_name   = aws_ecs_cluster.server_cluster.name
    service_name   = aws_ecs_service.service.name
  }
}

output "logging" {
  value = {
    log_group_name = aws_cloudwatch_log_group.server_log_group.name
    syslog_log_group_name = aws_cloudwatch_log_group.syslog_log_group.name
  }
}

