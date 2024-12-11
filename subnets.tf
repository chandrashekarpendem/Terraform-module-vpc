module "public_subnets" {
  source = "./subnets"

  env               = var.env
  default_vpc_id    = var.default_vpc_id
  availability_zone = var.availability_zone

  for_each          = var.public_subnets
  cidr_block        = each.value.cidr_block
  name              = each.value.name
  nat_gw            = lookup(each.value,nat_gw "false" )
  internet_gw       = lookup(each.value,internet_gw "false" )

  vpc_id            = aws_vpc.infra_vpc.id
  vpc_peering_connection_id = aws_vpc_peering_connection.auto_peer.id
  tags              = local.common_tags
  gateway_id        = aws_internet_gateway.igw.id
}

module "private_subnets" {
  source = "./subnets"

  env               = var.env
  default_vpc_id    = var.default_vpc_id
  availability_zone = var.availability_zone

  for_each          = var.private_subnets
  cidr_block        = each.value.cidr_block
  name              = each.value.name
  nat_gw            = lookup(each.value,nat_gw "false" )
  internet_gw       = lookup(each.value,internet_gw "false" )

  vpc_id            = aws_vpc.infra_vpc.id
  vpc_peering_connection_id = aws_vpc_peering_connection.auto_peer.id
  tags              = local.common_tags
  nat_gateway_id        = aws_nat_gateway.nat_gw.id
}