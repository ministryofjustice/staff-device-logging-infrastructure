.PHONY: bootstrap

bootstrap:
	cd bootstrap && terraform init && terraform apply
