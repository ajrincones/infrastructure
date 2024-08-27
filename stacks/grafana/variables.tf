
# ALB
variable "alb_dns_name" {
  type = string
}

variable "dns_ccm" {
  type = string
}

variable "alb_zone_id" {
  type = string
}

variable "public_route53_hosted_zone_id" {
  type = string
}

# Grafana
variable "grafana_version" {
  type = string
}

variable "grafana_secret_admin" {
  type = string
}

variable "grafana_secret_sendgrid" {
  type = string
}

# EFS
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