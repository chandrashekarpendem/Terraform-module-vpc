data "aws_caller_identity" "current_account" {}
data "awc_vpc" "default_vpc_info" {
  id = var.default_vpc_id
}