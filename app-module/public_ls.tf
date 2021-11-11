resource "aws_lb_listener" "Public-Listener" {
  count   = var.is_internal == "true" ? 0 : 1
  load_balancer_arn = data.terraform_remote_state.ALB.outputs.Public-LB-ARN
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
    
}

resource "aws_lb_listener" "Public-Listener-https" {
  count   = var.is_internal == "true" ? 0 : 1
  load_balancer_arn = data.terraform_remote_state.ALB.outputs.Public-LB-ARN
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:us-east-1:795902710157:certificate/41c4a20f-3062-4980-b4ee-8d74485d3cf0"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-group.arn
  }
    
}