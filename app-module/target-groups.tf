resource "aws_lb_target_group" "target-group" {
  name     = "${var.component}-${var.env}-TG"
  port     = var.port
  protocol = "HTTP"
  vpc_id      = data.terraform_remote_state.vpc.outputs.VPC_ID
  health_check   {
    enabled = true
    healthy_threshold = 2
    interval = 5
    timeout = 3
    path  = "/health"
    port  = var.port
    unhealthy_threshold = 3
  }
}

resource "aws_lb_listener_rule" "LB_IN_RULES" {
 count   = var.is_internal == "true" ? 1 : 0
  listener_arn = data.terraform_remote_state.ALB.outputs.Internal-Listener
  priority     = var.priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-group.arn
  }

  condition {
    host_header {
      values = ["${var.component}-${var.env}.krishna.roboshop"]
    }
  }
}