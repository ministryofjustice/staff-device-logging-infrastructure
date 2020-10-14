resource "aws_acm_certificate" "api_gateway_logging" {
  domain_name       = var.api_gateway_custom_domain
  validation_method = "DNS"

  tags = var.tags
}

resource "aws_acm_certificate_validation" "api_gateway_logging" {
  certificate_arn         = aws_acm_certificate.api_gateway_logging.arn
  validation_record_fqdns = [for record in aws_route53_record.api_gateway_logging : record.fqdn]
}

resource "aws_route53_record" "api_gateway_logging" {
  for_each = {
    for dvo in aws_acm_certificate.api_gateway_logging.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  name    = each.value.name
  records = [each.value.record]
  ttl     = 3600
  type    = each.value.type
  zone_id = var.vpn_hosted_zone_id
}
