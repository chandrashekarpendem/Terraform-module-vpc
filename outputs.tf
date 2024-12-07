output "vpc_id" {
  value = aws_vpc.infra_vpc.id
}

output "vpc_peering_connection_id" {
  value = aws_vpc_peering_connection.auto_peer.id
}

output "gateway_id" {
  value = aws_internet_gateway.igw.id
}