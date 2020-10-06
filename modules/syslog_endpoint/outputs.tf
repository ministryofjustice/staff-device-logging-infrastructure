output "ecr" {
  value = {
    repository_url = aws_ecr_repository.docker_repository.repository_url
    registry_id    = aws_ecr_repository.docker_repository.registry_id
  }
}

output "health_check_ecr" {
  value = {
    repository_url = aws_ecr_repository.health_check_docker_repository.repository_url
    registry_id    = aws_ecr_repository.health_check_docker_repository.registry_id
  }
}

