# Locals
locals {
  Stack = "Networking"
}

variable "alleata_dev_vpc_id" {
  type = string
}

variable "alleata_dev_cidr" {
  type = string
}

# EKS
variable "cluster_name" {
  type = string
}

# VPC
variable "vpc_cidr" {
  type = string
}

variable "vpc_dns_hostnames" {
  type = bool
}

variable "vpc_dns_support" {
  type = bool
}

# Subnets
variable "private_a_az" {
  type = string
}

variable "private_a_cidr" {
  type = string
}

variable "public_a_az" {
  type = string
}

variable "public_a_cidr" {
  type = string
}

variable "private_b_az" {
  type = string
}

variable "private_b_cidr" {
  type = string
}

variable "public_b_az" {
  type = string
}

variable "public_b_cidr" {
  type = string
}

variable "private_c_az" {
  type = string
}

variable "private_c_cidr" {
  type = string
}

variable "public_c_az" {
  type = string
}

variable "public_c_cidr" {
  type = string
}