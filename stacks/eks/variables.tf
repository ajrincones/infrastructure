locals {
  Stack    = "EKS"
  eks_name = "Zeus"
}

variable "ccm_crt" {
  type = string
}

# Loki
variable "loki_bucket_name" {
  type = string
}

# AWS
variable "AWS_REGION" {
  type = string
}

variable "AWS_ACCOUNT" {
  type = number
}

# EKS
variable "eks_efs_csi_version" {
  type = string
}

variable "grafana_acm" {
  type = string
}

variable "eks_version" {
  type = string
}

variable "eks_asc_image" {
  type = string
}

variable "eks_load_balancer_controller_version" {
  type = string
}

variable "eks_metrics_server_version" {
  type = string
}

variable "eks_ami_version" {
  type = string
}

variable "eks_instance_types" {
  type = list(string)
}

variable "eks_node_a_desired" {
  type = number
}

variable "eks_node_a_max" {
  type = number
}

variable "eks_node_a_min" {
  type = number
}

variable "eks_node_b_desired" {
  type = number
}

variable "eks_node_b_max" {
  type = number
}

variable "eks_node_b_min" {
  type = number
}

# IAM 
variable "iam_admin_arn_conexa" {
  type = string
}

# VPC
variable "vpc" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "private_subnet_a" {
  type = string
}

variable "private_subnet_b" {
  type = string
}
variable "private_subnet_c" {
  type = string
}

variable "public_subnet_a" {
  type = string
}

variable "public_subnet_b" {
  type = string
}
variable "public_subnet_c" {
  type = string
}