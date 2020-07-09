module "iam-panw-sop-oci-access" {
  source                      = "../iam"
  iam-name                    = "${var.prefix}-code-build-panw-sop-oci-access"
  shared_services_account_arn = var.shared_services_account_arn
}
