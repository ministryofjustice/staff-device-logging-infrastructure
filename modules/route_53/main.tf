locals {
  custom_domain_name_count = var.enable_api_gateway_custom_domain ? 1 : 0
  custom_domain = "${var.env}.logcollector.secops.justice.gov.uk"
}

resource "aws_route53_zone" "env" {
  count = local.custom_domain_name_count
  name  = local.custom_domain
}

resource "aws_route53_record" "log_collector_ns" {
  count           = local.custom_domain_name_count
  zone_id         = element(aws_route53_zone.env.*.zone_id, 0)
  allow_overwrite = true
  name            = local.custom_domain
  type            = "NS"
  ttl             = "30"

  records = [
    element(aws_route53_zone.env.*.name_servers.0, 0),
    element(aws_route53_zone.env.*.name_servers.1, 0),
    element(aws_route53_zone.env.*.name_servers.2, 0),
    element(aws_route53_zone.env.*.name_servers.3, 0)
  ]
}
