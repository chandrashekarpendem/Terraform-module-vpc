variable "cidr_block" {}
variable "availability_zone" {}
variable "vpc_id" {}
variable "env" {}
variable "name" {}
variable "vpc_peering_connection_id" {}
variable "default_vpc_id" {}
variable "tags" {}
variable "internet_gw" {}
variable "nat_gw" {}

variable "gateway_id" {
  default = null

}
variable "nat_gw_id" {
  default = null
}