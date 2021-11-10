data "terraform_remote_state" "vpc" {
  backend = "s3" 

  config = {
    bucket = "dasari1998"
    key    = "Terraform-mutable/vpc/${var.env}/${var.env}_state_file_backup"
    region = "us-east-1"
  }
}


data "aws_route53_zone" "route53" {
  name         = "krishna.roboshop"
  private_zone = true
}

