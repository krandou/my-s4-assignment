# provider blocks
provider "aws" {
  region = local.aws_region
}

# terraform blocks
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

terraform {
  backend "s3" {
    bucket         = "2560-clovis-s4-state"
    dynamodb_table = "2560-clovis-s4-state-lock"
    key            = "eks-node-group-s4/terraform.tfstate"
    region         = "us-east-1"
  }
}
locals {
  aws_region   = "us-east-1"
  desired_size = "2"
  min_size     = "2"
  max_size     = "5"
  common_tags = {
    "AssetID"       = "2526"
    "AssetName"     = "Insfrastructure"
    "Teams"         = "DEL"
    "Environment"   = "dev"
    "Project"       = "alpha"
    "CreateBy"      = "Terraform"
    "cloudProvider" = "aws"
  }

}

module "vpc" {
  source       = "../../../modules/eks-node-group"
  aws_region   = local.aws_region
  common_tags  = local.common_tags
  desired_size = local.desired_size
  min_size     = local.min_size
  max_size     = local.max_size
}
