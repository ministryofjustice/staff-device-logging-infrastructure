module "iam-tgw" {
  source                      = "../iam"
  iam-name                    = "SharedServicesCodeBuild"
  shared_services_account_arn = var.shared_services_account_arn
}
