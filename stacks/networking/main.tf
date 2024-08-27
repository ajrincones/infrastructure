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
    key            = "stateFiles/networking.json"
    region         = "us-east-1"
  }
}

provider "aws" {
  region                   = "us-east-1"
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "default"
}
