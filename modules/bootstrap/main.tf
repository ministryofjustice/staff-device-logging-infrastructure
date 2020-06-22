module "iam-logging" {
  source                      = "../iam"
  iam-name                    = "SharedServicesCodeBuild"
  shared_services_account_arn = var.shared_services_account_arn
}

module "iam-tgw" {
  source                      = "../iam"
  iam-name                    = "CodeBuildTGW"
  shared_services_account_arn = var.shared_services_account_arn
}

module "iam-panw-panorama-policy-config" {
  source                      = "../iam"
  iam-name                    = "CodeBuildPanwPanoramaPolicyConfig"
  shared_services_account_arn = var.shared_services_account_arn
}

module "iam-panw-panorama-base-config" {
  source                      = "../iam"
  iam-name                    = "CodebuildPanwPanoramaBaseConfig"
  shared_services_account_arn = var.shared_services_account_arn
}

module "iam-panw-panorama" {
  source                      = "../iam"
  iam-name                    = "CodeBuildPanwPanorama"
  shared_services_account_arn = var.shared_services_account_arn
}

module "iam-panw-outbound" {
  source                      = "../iam"
  iam-name                    = "CodeBuildPanwOutbound"
  shared_services_account_arn = var.shared_services_account_arn
}

module "iam-panw-inbound" {
  source                      = "../iam"
  iam-name                    = "CodeBuildPanwInbound"
  shared_services_account_arn = var.shared_services_account_arn
}

module "iam-panw-global-protect" {
  source                      = "../iam"
  iam-name                    = "CodeBuildPanwGlobalProtect"
  shared_services_account_arn = var.shared_services_account_arn
}

module "iam-panw-global-east-west" {
  source                      = "../iam"
  iam-name                    = "CodeBuildPanwEastWest"
  shared_services_account_arn = var.shared_services_account_arn
}
