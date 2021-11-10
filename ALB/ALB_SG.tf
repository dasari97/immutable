resource "aws_security_group" "ALB_internal_SG" {
  name        = "ALB_Internal_SG_${var.env}"
  description = "Allow Internal Instances"
  vpc_id      = data.terraform_remote_state.vpc.outputs.VPC_ID 

  ingress = [
    {
      description      = "http"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = data.terraform_remote_state.vpc.outputs.vpc_cidr
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      self             = false
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
    Name = "ALB_Internal_SG_${var.env}"
  }
}

resource "aws_security_group" "ALB_public_SG" {
  name        = "ALB_public_SG_${var.env}"
  description = "Allow Public Instances"
  vpc_id      = data.terraform_remote_state.vpc.outputs.VPC_ID 

  ingress = [
    {
      description      = "http"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      self             = false
      security_groups  = []
    },
    {
      description      = "https"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      self             = false
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
    Name = "ALB_public_SG_${var.env}"
  }
}