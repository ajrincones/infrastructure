resource "aws_route53_record" "ccm" {
  zone_id = var.public_route53_hosted_zone_id
  name    = var.dns_ccm
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}
