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
    key            = "stateFiles/eks.json"
    region         = "us-east-1"
  }
}

provider "aws" {
  region                   = "us-east-1"
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "default"
}

provider "helm" {
  kubernetes {
    host                   = aws_eks_cluster.zeus.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.zeus.certificate_authority[0].data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.zeus.id]
      command     = "aws"
    }
  }
}

provider "kubernetes" {
  host                   = aws_eks_cluster.zeus.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.zeus.certificate_authority[0].data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.zeus.id]
    command     = "aws"
  }
}

