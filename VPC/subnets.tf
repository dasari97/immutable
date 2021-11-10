resource "aws_subnet" "public" {
  count      = length(var.subnet_public_cidr)
  vpc_id     = aws_vpc.vpc.id
  cidr_block = element(var.subnet_public_cidr, count.index)
  availability_zone = element(var.AZS, count.index)

  tags = {
    Name = "public_subnet_${count.index +1}"
  }
}

resource "aws_subnet" "private" {
  depends_on = [aws_route_table.private_routeTable]
  count      = length(var.subnet_private_cidr)
  vpc_id     = aws_vpc.vpc.id
  cidr_block = element(var.subnet_private_cidr, count.index)
  availability_zone = element(var.AZS, count.index)

  tags = {
    Name = "private_subnet_${count.index +1}"
  }
}