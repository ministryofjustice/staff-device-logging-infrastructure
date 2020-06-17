.PHONY: bootstrap init-development

bootstrap:
	cd bootstrap && terraform init && terraform apply

init-development:
	terraform init --backend-config="bucket=pttp-development-pttp-infrastructure-tf-remote-state"
