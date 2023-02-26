# Domain hosted zone
data "aws_route53_zone" "root_domain" {
  name = var.root_domain
  # private_zone = true
}

#certificate generation and validation:
resource "aws_acm_certificate" "certificate" {
  domain_name = format("%s.%s", var.subdomain, var.root_domain)
  validation_method = "DNS"
}

resource "aws_route53_record" "certificate_validation" {
  name    = tolist(aws_acm_certificate.certificate.domain_validation_options)[0].resource_record_name
  type    = tolist(aws_acm_certificate.certificate.domain_validation_options)[0].resource_record_type
  zone_id = data.aws_route53_zone.root_domain.zone_id
  records = [tolist(aws_acm_certificate.certificate.domain_validation_options)[0].resource_record_value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "certificate_validation" {
  certificate_arn         = aws_acm_certificate.certificate.arn
  validation_record_fqdns = [aws_route53_record.certificate_validation.fqdn]
}

resource "aws_api_gateway_domain_name" "domain_name" {
  domain_name = format("%s.%s", var.subdomain, var.root_domain)
  regional_certificate_arn = aws_acm_certificate_validation.certificate_validation.certificate_arn
  endpoint_configuration {
    types = [
      "REGIONAL",
    ]
  }
}

resource "aws_api_gateway_base_path_mapping" "path_mapping" {
  api_id      = aws_api_gateway_rest_api.api.id
  stage_name  = aws_api_gateway_stage.api.stage_name
  domain_name = aws_api_gateway_domain_name.domain_name.domain_name
}

/*resource "aws_api_gateway_domain_name" "domain_name" {
  domain_name = format("%s.%s", var.subdomain, var.root_domain)
  # regional_certificate_arn = aws_acm_certificate_validation.certificate_validation.certificate_arn
  regional_certificate_arn = data.aws_acm_certificate.certificate.arn
  endpoint_configuration {
    types = [
      "REGIONAL",
    ]
  }
}

resource "aws_api_gateway_base_path_mapping" "path_mapping" {
  api_id      = aws_api_gateway_rest_api.api.id
  stage_name  = aws_api_gateway_stage.api.stage_name
  domain_name = aws_api_gateway_domain_name.domain_name.domain_name
}

# Domain hosted zone
data "aws_route53_zone" "root_domain" {
  name = var.root_domain
  # private_zone = true
}

data "aws_acm_certificate" "certificate" {
  domain      = var.root_domain
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}*/

#creating route53 record for the domain to be used with REST API
resource "aws_route53_record" "sub_domain" {
  name = format("%s.%s", var.subdomain, var.root_domain)
  type    = "A"
  zone_id = data.aws_route53_zone.root_domain.zone_id
  alias {
    name                   = aws_api_gateway_domain_name.domain_name.regional_domain_name
    zone_id                = aws_api_gateway_domain_name.domain_name.regional_zone_id
    evaluate_target_health = false
  }
}