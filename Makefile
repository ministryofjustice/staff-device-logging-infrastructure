bootstrap-development:
	./scripts/apply_bootstrap development

bootstrap-pre-production:
	./scripts/apply_bootstrap pre-production

bootstrap-production:
	./scripts/apply_bootstrap production

process-dead-letter-queue:
	./scripts/process_dead_letter_queue

apply:
	aws-vault clear && aws-vault exec moj-pttp-shared-services --duration=2h -- terraform apply

destroy:
	aws-vault clear && aws-vault exec moj-pttp-shared-services --duration=2h -- terraform destroy

init:
	terraform init --backend-config="key=terraform.development.state" -reconfigure -upgrade

.PHONY: bootstrap-development bootstrap-pre-production bootstrap-production apply destroy
