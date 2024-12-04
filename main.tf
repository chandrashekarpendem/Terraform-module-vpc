resource "aws_vpc" "infra_vpc" {
  cidr_block = var.cidr_block
  tags       = merge(local.common_tags,{ Name= "${var.env}-vpc" })
}

resource "aws_subnet" "public_subnet" {
  count  = length(var.public_cidr_block)
  vpc_id = aws_vpc.infra_vpc.id
  cidr_block = var.public_cidr_block[count.index]
  tags       = merge(local.common_tags,{ Name= "${var.env}-public_subnet_${count.index + 1}" })
}

resource "aws_subnet" "private_subnet" {
  count  = length(var.private_cidr_block)
  vpc_id = aws_vpc.infra_vpc.id
  cidr_block = var.private_cidr_block[count.index]
  tags       = merge(local.common_tags,{ Name= "${var.env}-public_subnet_${count.index + 1}" })
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

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.infra_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  route {
    cidr_block = data.awc_vpc.default_vpc_info.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.auto_peer.id
  }
  tags       = merge(local.common_tags,{ Name= "${var.env}-public_route_table" })
}