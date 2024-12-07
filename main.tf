#when you create a vpc a default route table gets created automatically.
#that created route-table will automatically associated to subnets which are launched through  created vpc
#NOTE: We should not use tags argument for aws_route_table_association
resource "aws_vpc" "infra_vpc" {
  cidr_block = var.cidr_block
  tags       = merge(local.common_tags,{ Name= "${var.env}-vpc" })
}

#resource "aws_subnet" "public_subnet" {
#  count  = length(var.public_cidr_block)
#  availability_zone = var.availability_zones[count.index]
#  vpc_id = aws_vpc.infra_vpc.id
#  cidr_block = var.public_cidr_block[count.index]
#  tags       = merge(local.common_tags,{ Name= "${var.env}-public_subnet_${count.index + 1}" })
#}
#
#resource "aws_subnet" "private_subnet" {
#  count  = length(var.private_cidr_block)
#  availability_zone = var.availability_zones[count.index]
#  vpc_id = aws_vpc.infra_vpc.id
#  cidr_block = var.private_cidr_block[count.index]
#  tags       = merge(local.common_tags,{ Name= "${var.env}-private_subnet_${count.index + 1}" })
#}

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
##when we create route table we directly add the routes once the route table is associated to subnets it gets all routes what it has
#resource "aws_route_table" "public_route_table" {
#  vpc_id = aws_vpc.infra_vpc.id
#
#  route {
#    cidr_block = "0.0.0.0/0"
#    gateway_id = aws_internet_gateway.igw.id
#  }
#
#  route {
#    cidr_block = data.aws_vpc.default_vpc_info.cidr_block
#    vpc_peering_connection_id = aws_vpc_peering_connection.auto_peer.id
#  }
#  tags       = merge(local.common_tags,{ Name= "${var.env}-public_route_table" })
#}


#  we created two public subnets so we need to associate above public_route_table so we need to associate to two public_subnets
#resource "aws_route_table_association" "public_route_table_association_to_public_subnets" {
#  count = length(aws_subnet.public_subnet) # here we are iterating with count i.e you plz run times of public_subnet has
#  route_table_id = aws_route_table.public_route_table.id
#  subnet_id = aws_subnet.public_subnet.*.id[count.index]
#
#}

#as we created the public subnet and private subnet now we need to create a nat_gateway for private subnets
#but to create nat_gateway we need to have elastic_ip so creating elastic_ip

resource "aws_eip" "elastic_ip_for_NATGW" {
#  vpc = true used for old terraform version
  domain = "vpc"
  tags       = merge(local.common_tags,{ Name= "${var.env}-elastic_ip_for_NATGW" })
}

#here we are creating the nat_gate_way for private subnets but it should be created in public subnet so we have two public subnets,.
#resource "aws_nat_gateway" "NATGW_for_Private_subnets" {
#  subnet_id = aws_subnet.public_subnet.*.id[0] #so we are creating in 1st public subnets thorough .*.id[0]
#  allocation_id = aws_eip.elastic_ip_for_NATGW.id
#
#  tags       = merge(local.common_tags,{ Name= "${var.env}-NATGW_for_Private_subnets" })
#
#}

#so we created NATGW in public subnet and the private subnets can use this and get internet so, private subnets require private route table and tables need to associate with private subnets
#resource "aws_route_table" "private_route_table" {
#  vpc_id = aws_vpc.infra_vpc.id
#
#  route {
#    cidr_block = "0.0.0.0/0"
#    nat_gateway_id = aws_nat_gateway.NATGW_for_Private_subnets.id
#  }
#
#  route {
#    cidr_block = data.aws_vpc.default_vpc_info.cidr_block
#    vpc_peering_connection_id = aws_vpc_peering_connection.auto_peer.id
#  }
#  tags       = merge(local.common_tags,{ Name= "${var.env}-private_route_table" })
#}

#resource "aws_route_table_association" "private_route_table_association_to_private_subnets" {
#  count = length(aws_subnet.public_subnet) # here we are iterating with count i.e you plz run times of private_subnet has
#  route_table_id = aws_route_table.private_route_table.id
#  subnet_id = aws_subnet.private_subnet.*.id[count.index]
#
#}

#in our account we have default vpc and it has default main  default route table now if you go anbd check only it has local and igw
#routes , but we use a bastion node through vpc peering to connect to private instances, so we need add a route to that route table

#resource "aws_route" "adding_our_cidr_range_to_default_route_table" {
#  route_table_id = data.aws_vpc.default_vpc_info.main_route_table_id
#  destination_cidr_block = var.cidr_block
#  vpc_peering_connection_id = aws_vpc_peering_connection.auto_peer.id #here the vpc subnets will connect other through vpc_peering_connection
#}
