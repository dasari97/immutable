resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "redis-${var.env}"
  engine               = "redis"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis6.x"
  engine_version       = "6.x"
  port                 = 6379
  subnet_group_name    = aws_elasticache_subnet_group.subnet-group.name
  security_group_ids   = [aws_security_group.redis.id]
}

resource "aws_elasticache_subnet_group" "subnet-group" {
  name       = "redis-${var.env}"
  subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnet_ids
}

resource "aws_security_group" "redis" {
  name        = "redis-${var.env}"
  description = "Allow redis"
  vpc_id      = data.terraform_remote_state.vpc.outputs.VPC_ID 

  ingress = [
    {
      description      = "redis"
      from_port        = 6379
      to_port          = 6379
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
    Name = "redis-${var.env}"
  }
}

resource "aws_route53_record" "redis" {
  zone_id = data.aws_route53_zone.route53.zone_id
  name    = "redis-${var.env}.krishna.roboshop"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_elasticache_cluster.redis.cache_nodes[0].address]
}

