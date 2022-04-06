terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  cloud {
    organization = "athome"
    workspaces {
      name = "terraform-aws-cisco-ngfw-vpc"
    }
  }
}

