output "subnets_ids" {
  value = aws_subnet.subnet.*.id
}

output "app_cidr_block" {
  value = aws_subnet.subnet.*.cidr_block
}