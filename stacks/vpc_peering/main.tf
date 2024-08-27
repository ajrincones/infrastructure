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
    key            = "stateFiles/vpc_peering.json"
    region         = "us-east-1"
  }
}

provider "aws" {
  region                   = "us-east-1"
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "default"
}

provider "aws" {
  alias = "alleata_dev"

  region     = "us-east-1"
  access_key = var.alleata_dev_aws_key
  secret_key = var.alleata_dev_aws_secret
  token      = var.alleata_dev_aws_token
}
