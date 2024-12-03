resource "aws_vpc" "infra_vpc" {
  cidr_block = var.cidr_block
  tags       = merge(local.common_tags,{ Name= "${var.env}-vpc" })
}