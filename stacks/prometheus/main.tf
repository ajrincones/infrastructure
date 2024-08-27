terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    encrypt        = true
    bucket         = "shared-terraform-states"
    dynamodb_table = "TerraformStateFilesLock"
    key            = "stateFiles/prometheus.json"
    region         = "us-east-1"
  }
}

provider "helm" {
  kubernetes {
    host                   = var.eks_cluster_endpoint
    cluster_ca_certificate = base64decode(var.eks_cluster_ca)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", var.eks_cluster_name]
      command     = "aws"
    }
  }
}