data "aws_route53_zone" "zone" {
  name         = "${var.existing_public_domain}."
  private_zone = false
}

resource "aws_acm_certificate" "wildcard_certificate" {
  domain_name       = "*.${var.existing_public_domain}"
  validation_method = "DNS"
}

resource "aws_route53_record" "validation" {
  for_each = {
    for dvo in aws_acm_certificate.wildcard_certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.zone.zone_id
}

resource "aws_acm_certificate_validation" "wildcard_validation" {
  certificate_arn         = aws_acm_certificate.wildcard_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.validation : record.fqdn]
}
