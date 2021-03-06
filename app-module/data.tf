data "aws_ami" "ami" {
  most_recent      = true
  name_regex       = "${var.component}-${var.APP_VERSION}"
  owners           = ["self"]
  }
  
data "terraform_remote_state" "vpc" {
  backend = "s3" 

  config = {
    bucket = "dasari1998"
    key    = "Terraform-immutable/vpc/${var.env}/${var.env}_state_file_backup"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "ALB" {
  backend = "s3" 

  config = {
    bucket = "dasari1998"
    key    = "Terraform-immutable/ALB/${var.env}/${var.env}_state_file_backup"
    region = "us-east-1"
  }
}

data "aws_secretsmanager_secret" "Dev_secret" {
  name = var.env
}

data "aws_secretsmanager_secret_version" "Dev_secret" {
  secret_id = data.aws_secretsmanager_secret.Dev_secret.id
}

data "aws_route53_zone" "route53" {
  name         = "krishna.roboshop"
  private_zone = true
}

