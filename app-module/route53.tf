resource "aws_route53_record" "app-in-lb" {
  count   = var.is_internal == "true" ? 1 : 0
  zone_id = data.aws_route53_zone.route53.zone_id
  name    = "${var.component}-${var.env}.krishna.roboshop"
  type    = "CNAME"
  ttl     = "300"
  records = [data.terraform_remote_state.ALB.outputs.LB_INTERNAL_NAME]
}

resource "aws_route53_record" "app-pb-lb" {
  count   = var.is_internal == "true" ? 0 : 1
  zone_id = data.aws_route53_zone.route53.zone_id
  name    = "${var.component}-${var.env}.krishna.roboshop"
  type    = "CNAME"
  ttl     = "300"
  records = [data.terraform_remote_state.ALB.outputs.LB_PUBLIC_NAME]
}