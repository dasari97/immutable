resource "aws_db_subnet_group" "mysql_subnets" {
  name       = "${var.env}-db_sb-mysql"
  subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnet_ids

  tags = {
    Name = "${var.env}-db_sb-mysql"
  }
}

resource "aws_security_group" "mysql" {
  name        = "mysql-${var.env}"
  description = "Allow mysql"
  vpc_id      = data.terraform_remote_state.vpc.outputs.VPC_ID 

  ingress = [
    {
      description      = "mysql"
      from_port        = 3306
      to_port          = 3306
      protocol         = "tcp"
      cidr_blocks      = local.all_vpc_cidr
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
    Name = "mysql-${var.env}"
  }
}

resource "aws_db_instance" "mysql" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "terraform"
  username             = jsondecode(data.aws_secretsmanager_secret_version.Dev_secret.secret_string)["mysql_id"]
  password             = jsondecode(data.aws_secretsmanager_secret_version.Dev_secret.secret_string)["mysql_pass"]
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.mysql_subnets.name
  vpc_security_group_ids = [aws_security_group.mysql.id]
  identifier             = "mysql-${var.env}"
}

resource "aws_route53_record" "mysql" {
  zone_id = data.aws_route53_zone.route53.zone_id
  name    = "mysql-${var.env}.krishna.roboshop"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_db_instance.mysql.address]
}

resource "null_resource" "MySQL" {
depends_on = [aws_route53_record.mysql]
#triggers = {
    #A = timestamp()
#}
    provisioner "local-exec" {
        command = <<EOT
            curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip"
            cd /tmp
            unzip mysql.zip
            cd mysql-main
            mysql -h mysql-${var.env}.krishna.roboshop -u ${jsondecode(data.aws_secretsmanager_secret_version.Dev_secret.secret_string)["mysql_id"]} -p${jsondecode(data.aws_secretsmanager_secret_version.Dev_secret.secret_string)["mysql_pass"]} <shipping.sql
        
         EOT
    }
}

 
/*mysql-${var.env}.krishna.roboshop
mysql-dev.krishna.roboshop*/