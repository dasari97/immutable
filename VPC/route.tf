resource "aws_route_table" "public_routeTable" {
  vpc_id = aws_vpc.vpc.id

  route = [
   {
      cidr_block                 = var.default_vpc_cidr
      vpc_peering_connection_id  = aws_vpc_peering_connection.peer1.id
      gateway_id                 = ""
      carrier_gateway_id         = ""
      destination_prefix_list_id = ""
      egress_only_gateway_id     = ""
      instance_id                = ""
      ipv6_cidr_block            = ""
      local_gateway_id           = ""
      nat_gateway_id             = ""
      network_interface_id       = ""
      transit_gateway_id         = ""
      vpc_endpoint_id            = ""
    },
    
    {
      cidr_block                 = "0.0.0.0/0"
      vpc_peering_connection_id  = ""
      gateway_id                 = aws_internet_gateway.IGW.id
      carrier_gateway_id         = ""
      destination_prefix_list_id = ""
      egress_only_gateway_id     = ""
      instance_id                = ""
      ipv6_cidr_block            = ""
      local_gateway_id           = ""
      nat_gateway_id             = ""
      network_interface_id       = ""
      transit_gateway_id         = ""
      vpc_endpoint_id            = ""
    }
    
    ]

  tags = {
    Name = "Public_RT_${var.env}-vpc"
  }
}

resource "aws_route_table" "private_routeTable" {
  vpc_id = aws_vpc.vpc.id

  route = [
   {
      cidr_block                 = var.default_vpc_cidr
      vpc_peering_connection_id  = aws_vpc_peering_connection.peer1.id
      gateway_id                 = ""
      carrier_gateway_id         = ""
      destination_prefix_list_id = ""
      egress_only_gateway_id     = ""
      instance_id                = ""
      ipv6_cidr_block            = ""
      local_gateway_id           = ""
      nat_gateway_id             = ""
      network_interface_id       = ""
      transit_gateway_id         = ""
      vpc_endpoint_id            = ""
    },
  
  {
      cidr_block                 = "0.0.0.0/0"
      vpc_peering_connection_id  = ""
      gateway_id                 = ""
      carrier_gateway_id         = ""
      destination_prefix_list_id = ""
      egress_only_gateway_id     = ""
      instance_id                = ""
      ipv6_cidr_block            = ""
      local_gateway_id           = ""
      nat_gateway_id             = aws_nat_gateway.NGW.id
      network_interface_id       = ""
      transit_gateway_id         = ""
      vpc_endpoint_id            = ""
    }
  ]

  tags = {
    Name = "Private_RT_${var.env}-vpc"
  }
}

#resource "aws_route" "Public-peer-add" {
#  route_table_id            = aws_route_table.public_routeTable.id
#  destination_cidr_block    = var.default_vpc_cidr
#  vpc_peering_connection_id = aws_vpc_peering_connection.peer1.id
#}

#resource "aws_route" "Private-peer-add" {
#  route_table_id            = aws_route_table.private_routeTable.id
#  destination_cidr_block    = var.default_vpc_cidr
#  vpc_peering_connection_id = aws_vpc_peering_connection.peer1.id
#}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public.*.id)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public_routeTable.id
}

resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private.*.id)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private_routeTable.id
}

resource "aws_route" "default_vpc_rt_private" {
  count                     = length(var.vpc_private_cidr)
  route_table_id            = var.default_RT_id
  destination_cidr_block    = element(var.vpc_private_cidr ,count.index)
  vpc_peering_connection_id = aws_vpc_peering_connection.peer1.id
}

resource "aws_route" "default_vpc_rt_public" {
  route_table_id            = var.default_RT_id
  destination_cidr_block    = var.vpc_public_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peer1.id
}

