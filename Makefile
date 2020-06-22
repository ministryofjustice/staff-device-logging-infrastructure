bootstrap-development:
	./scripts/apply_bootstrap development

bootstrap-pre-production:
	./scripts/apply_bootstrap pre-production

bootstrap-production:
	./scripts/apply_bootstrap production

apply-development:
	./scripts/apply_environment development

apply-pre-production:
	./scripts/apply_environment pre-production

apply-production:
	./scripts/apply_environment production

.PHONY: apply-development apply-pre-production bootstrap-development bootstrap-pre-production bootstrap-production apply-production
