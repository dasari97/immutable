resource "aws_vpc_peering_connection" "peer1" {
  peer_owner_id = data.aws_caller_identity.account_ID.account_id
  peer_vpc_id   = aws_vpc.vpc.id
  vpc_id        = var.default_vpc
  auto_accept   = true
  
  tags               = {
    Name           = "${var.env}_peer"
    
}
}