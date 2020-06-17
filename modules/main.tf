module "iam-tgw" {
  source = "./iam"
  iam-name = "CodeBuildTGW"
}

module "iam-panw-panorama-policy-config" {
  source = "./iam"
  iam-name = "CodeBuildPanwPanoramaPolicyConfig"
}

module "iam-panw-panorama-base-config" {
  source = "./iam"
  iam-name = "CodebuildPanwPanoramaBaseConfig"
}

module "iam-panw-panorama" {
  source = "./iam"
  iam-name = "CodeBuildPanwPanorama"
}

module "iam-panw-outbound" {
  source = "./iam"
  iam-name = "CodeBuildPanwOutbound"
}

module "iam-panw-inbound" {
  source = "./iam"
  iam-name = "CodeBuildPanwInbound"
}

module "iam-panw-global-protect" {
  source = "./iam"
  iam-name = "CodeBuildPanwGlobalProtect"
}

module "iam-panw-global-east-west" {
  source = "./iam"
  iam-name = "CodeBuildPanwEastWest"
}
