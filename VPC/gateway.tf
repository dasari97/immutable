resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "Internet_GW_${var.env}"
  }
}

resource "aws_nat_gateway" "NGW" {
  allocation_id = aws_eip.NGW_ip.id
  subnet_id     = aws_subnet.public.*.id[0]

  tags = {
    Name = "NAT_GW-${var.env}"
  }
  depends_on = [aws_internet_gateway.IGW]
}

resource "aws_eip" "NGW_ip" {
  vpc      = true
}