terraform {
  backend "s3" {}
  required_version = ">= 1.14.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.35.0"
    }
  }
}

provider "aws" {
  # Default tags to be applied to all resources created by this provider
  default_tags {
    tags = {
      Repository = "terraform-project-template"
      ManagedBy  = "terraform"
    }
  }
}
