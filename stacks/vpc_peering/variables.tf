locals {
  Stack = "VPC_Peering"
}

variable "alleata_dev_vpc_id" {
  type = string
}

variable "alleata_dev_account_id" {
  type = number
}

variable "shared_vpc_id" {
  type = string
}

variable "r53_zone_id_private" {
  type = string
}

variable "alleata_dev_aws_key" {
  type = string
}

variable "alleata_dev_aws_secret" {
  type = string
}

variable "alleata_dev_aws_token" {
  type = string
}