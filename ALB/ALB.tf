resource "aws_lb" "Internal" {
  name               = "Internal-${var.env}"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ALB_internal_SG.id]
  subnets            = data.terraform_remote_state.vpc.outputs.private_subnet_ids

  tags = {
    Environment = "Internal-${var.env}"
  }
}

resource "aws_lb" "public" {
  name               = "public-${var.env}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ALB_public_SG.id]
  subnets            = data.terraform_remote_state.vpc.outputs.public_subnet_ids

  tags = {
    Environment = "public-${var.env}"
  }
}

resource "aws_lb_listener" "Internal-Listener" {
  load_balancer_arn = aws_lb.Internal.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "OK"
      status_code  = "200"
    }
  }
}