resource "aws_route53_record" "DNS" {
  count   = var.env == "prod" ? 1 : 0
  zone_id = data.aws_route53_zone.DNS.zone_id
  name    = "robo-${var.env}.dasariroboshop.online"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_lb.public.dns_name]
}