resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc_public_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  
tags               = {
    Name           = "${var.env}_vpc"
    
}
}

resource "aws_vpc_ipv4_cidr_block_association" "private_cidr" {
  count      = length(var.vpc_private_cidr)
  vpc_id     = aws_vpc.vpc.id
  cidr_block = element(var.vpc_private_cidr, count.index)
}