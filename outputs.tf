output "vpc_id" {
  value = aws_vpc.infra_vpc.id
}

output "vpc_peering_connection_id" {
  value = aws_vpc_peering_connection.auto_peer.id
}

output "public_subnets_ids" {
  value = module.public_subnets
}


output "private_subnets_ids" {
  value = module.private_subnets
}