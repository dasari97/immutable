resource "aws_route53_zone_association" "roboshop" {
  zone_id = data.aws_route53_zone.route53.zone_id
  vpc_id  = aws_vpc.vpc.id
}