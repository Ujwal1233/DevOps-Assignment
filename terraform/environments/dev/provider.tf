# Terraform Provider Configuration

terraform {
  required_version = ">= 1.0.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# AWS Provider
provider "aws" {
  region = "ap-south-1"
  
  default_tags {
    tags = {
      Project     = "DevOps-Assignment"
      ManagedBy   = "Terraform"
    }
  }
}
