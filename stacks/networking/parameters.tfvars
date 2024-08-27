# EKS
cluster_name = "Zeus"

# VPC
vpc_cidr          = "10.0.0.0/16"
vpc_dns_hostnames = true
vpc_dns_support   = true

# Subnets
private_a_cidr = "10.0.0.0/22"
private_a_az   = "us-east-1a"
public_a_cidr  = "10.0.4.0/22"
public_a_az    = "us-east-1a"

private_b_cidr = "10.0.8.0/22"
private_b_az   = "us-east-1b"
public_b_cidr  = "10.0.12.0/22"
public_b_az    = "us-east-1b"

private_c_cidr = "10.0.16.0/22"
private_c_az   = "us-east-1c"
public_c_cidr  = "10.0.20.0/22"
public_c_az    = "us-east-1c"

# Alleata VPC 
alleata_dev_vpc_id = "vpc-de9516a3"
alleata_dev_cidr   = "172.31.0.0/16"