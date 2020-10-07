output "ecr" {
  value = {
    repository_url = aws_ecr_repository.docker_repository.repository_url
    registry_id    = aws_ecr_repository.docker_repository.registry_id
    cluster_name   = aws_ecs_cluster.server_cluster.name
    service_name   = aws_ecs_service.service.name
  }
}

output "health_check_ecr" {
  value = {
    repository_url = aws_ecr_repository.health_check_docker_repository.repository_url
    registry_id    = aws_ecr_repository.health_check_docker_repository.registry_id
  }
}

