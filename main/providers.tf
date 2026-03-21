terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  backend "s3" {
    bucket         = "astronautics-infra-state-bucket"
    key            = "bootstrap/terraform.tfstate"
    region         = "us-east-1" # We going with defaults mostly for this console
    dynamodb_table = "astronautics-terraform-state-locks"
    encrypt        = true
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}
