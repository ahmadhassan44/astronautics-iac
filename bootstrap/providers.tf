terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  # No backend block here. It uses local state.
}

provider "aws" {
  region = "us-east-1"
}
