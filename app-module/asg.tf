resource "aws_autoscaling_group" "asg" {
  name                      = "${var.component}-${var.env}-asg"
  max_size                  = var.max_size
  min_size                  = var.min_size
  desired_capacity          = var.desired_capacity
  target_group_arns          = [aws_lb_target_group.target-group.arn]
  vpc_zone_identifier       = data.terraform_remote_state.vpc.outputs.private_subnet_ids
  
  launch_template   {
      id    =   aws_launch_template.template.id
      version = "$Latest"
  }
  
  tag {
    key                 = "Name"
    value               = "${var.component}-${var.env}-asg"
    propagate_at_launch = true
  }
  
  tag {
    key                 = "Monitor"
    value               = "yes"
    propagate_at_launch = true
  }
}
