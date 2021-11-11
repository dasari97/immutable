resource "aws_launch_template" "template" {
  name = "${var.component}-${var.env}-template"
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.app.id]
  image_id = data.aws_ami.ami.id
  
  instance_market_options {
    market_type = "spot"
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.component}-${var.env}-template"
    }
  }

//  user_data = filebase64("${path.module}/example.sh")
}

resource "aws_security_group" "app" {
  name        = "${var.component}-${var.env}"
  description = "Allow ${var.component}"
  vpc_id      = data.terraform_remote_state.vpc.outputs.VPC_ID 

  ingress = [
    {
      description      = "ssh"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = local.all_vpc_cidr
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      self             = false
      security_groups  = []
    },
    
    {
      description      = "8080 app port"
      from_port        = var.port
      to_port          = var.port
      protocol         = "tcp"
      cidr_blocks      = data.terraform_remote_state.vpc.outputs.vpc_cidr
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      self             = false
      security_groups  = []
    },
    
     {
      description      = "PROMETHEUS"
      from_port        = 9100
      to_port          = 9100
      protocol         = "tcp"
      cidr_blocks      = local.all_vpc_cidr
      ipv6_cidr_blocks = []
      self             = false
      prefix_list_ids  = []
      security_groups  = []
    }
  ]

  egress = [
    {
      description      = "ALL"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      self             = false
      security_groups  = []
    }
  ]

  tags = {
    Name = "${var.component}-${var.env}-template"
  }
}