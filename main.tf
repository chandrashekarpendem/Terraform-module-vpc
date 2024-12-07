#when you create a vpc a default route table gets created automatically.
#that created route-table will automatically associated to subnets which are launched through  created vpc
#NOTE: We should not use tags argument for aws_route_table_association

resource "aws_vpc" "infra_vpc" {
  cidr_block = var.cidr_block
  tags       = merge(local.common_tags,{ Name= "${var.env}-vpc" })
}

resource "aws_vpc_peering_connection" "auto_peer" {
  peer_owner_id = data.aws_caller_identity.current_account.account_id
  peer_vpc_id = var.default_vpc_id
  vpc_id      = aws_vpc.infra_vpc.id
  auto_accept = true
  tags       = merge(local.common_tags,{ Name= "${var.env}-peering_connection" })
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.infra_vpc.id
  tags       = merge(local.common_tags,{ Name= "${var.env}-igw" })
}


resource "aws_eip" "elastic_ip_for_NATGW" {
#  vpc = true used for old terraform version
  domain = "vpc"
  tags       = merge(local.common_tags,{ Name= "${var.env}-elastic_ip_for_NATGW" })
}






