locals {
  Stack = "Loki"
}

variable "loki_keys" {
  type = string
}

variable "private_route53_hosted_zone_id" {
  type = string
}

# ALB
variable "alb_dns_name" {
  type = string
}

variable "dns_loki" {
  type = string
}

variable "alb_zone_id" {
  type = string
}

variable "public_route53_hosted_zone_id" {
  type = string
}

# AWS
variable "AWS_REGION" {
  type = string
}

# Loki
variable "loki_version" {
  type = string
}

variable "storage_class_name" {
  type = string
}

# EKS
variable "eks_cluster_ca" {
  type = string
}

variable "eks_cluster_endpoint" {
  type = string
}

variable "eks_cluster_name" {
  type = string
}