# EKS
eks_version                          = "1.30"
eks_ami_version                      = "1.30.0-20240703" #/aws/service/eks/optimized-ami/1.30/amazon-linux-2023/arm64/standard/recommended/release_version
eks_metrics_server_version           = "3.12.1"
eks_load_balancer_controller_version = "1.8.1"
eks_efs_csi_version                  = "v2.0.5-eksbuild.1"
eks_asc_image                        = "registry.k8s.io/autoscaling/cluster-autoscaler:v1.30.2"
eks_instance_types                   = ["r6g.large", "t4g.large", "t4g.medium"]
grafana_acm                          = "arn:aws:acm:us-east-1:682033490598:certificate/356448e3-a979-45bf-8f7e-d7f0e6079518"
ccm_crt                              = "arn:aws:acm:us-east-1:682033490598:certificate/b0ebfe22-d5ad-4abb-9691-fd7759be71f9"

# NodeA
eks_node_a_desired = 1
eks_node_a_max     = 5
eks_node_a_min     = 1

# NodeB
eks_node_b_desired = 1
eks_node_b_max     = 5
eks_node_b_min     = 1

# IAM 
iam_admin_arn_conexa = "arn:aws:iam::682033490598:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_AdministratorAccess_aee2a9747f8c7b1b"

# VPC
vpc              = "vpc-03e50bfc88cd342a8"
vpc_cidr         = "10.0.0.0/16"
private_subnet_a = "subnet-012bcdd6d8385101b"
private_subnet_b = "subnet-06243bf12bca51a04"
private_subnet_c = "subnet-0de38dadbebf2e411"
public_subnet_a  = "subnet-0fc6ef490bcbef25e"
public_subnet_b  = "subnet-045289994664d4cbc"
public_subnet_c  = "subnet-0f7f09e63e642b620"

# AWS
AWS_ACCOUNT = 682033490598
AWS_REGION  = "us-east-1"

# Loki
loki_bucket_name = "conexa-loki-storage"