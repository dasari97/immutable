resource "aws_autoscaling_group" "asg" {
  name                      = "${var.component}-${var.env}-asg"
  max_size                  = 1
  min_size                  = 1
  desired_capacity          = 1
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
}
