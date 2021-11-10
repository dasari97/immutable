resource "aws_spot_instance_request" "mongodb" {
  ami           = data.aws_ami.ami.id
  instance_type = var.mongodb_instance_type
  subnet_id     = data.terraform_remote_state.vpc.outputs.private_subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.mongodb.id]
  wait_for_fulfillment   = true
  

  tags = {
    Name = "Mongodb-${var.env}"
  }
}

resource "aws_ec2_tag" "mongodb" {
  resource_id = aws_spot_instance_request.mongodb.spot_instance_id
  key         = "Name"
  value       = "Mongodb-${var.env}"
}

resource "aws_security_group" "mongodb" {
  name        = "mongodb-${var.env}"
  description = "Allow mongodb"
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
      description      = "mongodb"
      from_port        = 27017
      to_port          = 27017
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
    Name = "mongodb-${var.env}"
  }
}


resource "null_resource" "mongodb" {
  #triggers = {
    #abc = timestamp()
  #}
  # remove comment's when you want to run the mongodb null resource
  #triggers = {
   # abc = aws_spot_instance_request.mongodb.private_ip
  #}
  
  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = jsondecode(data.aws_secretsmanager_secret_version.Dev_secret.secret_string)["ssh_user"]
      password = jsondecode(data.aws_secretsmanager_secret_version.Dev_secret.secret_string)["ssh_pass"]
      host     = aws_spot_instance_request.mongodb.private_ip
    }
    
    inline = [
      "sudo yum install python3-pip -y",
      "sudo pip3 install pip --upgrade",
      "sudo pip3 install ansible==4.1.0",
      "ansible-pull -i localhost -U https://dasarisaikrishna97@dev.azure.com/dasarisaikrishna97/Roboshop/_git/ansible-roboshop.git roboshop-pull.yml -e COMPONENT=mongodb"
    ]
  }
  
}

resource "aws_route53_record" "mongodb" {
  zone_id = data.aws_route53_zone.route53.zone_id
  name    = "mongodb-${var.env}.krishna.roboshop"
  type    = "A"
  ttl     = "300"
  records = [aws_spot_instance_request.mongodb.private_ip]
}

