terraform {
  backend "s3" {
    bucket = "kabatrinkerlearn-deploy"
    key    = "terraform"
    region = "eu-central-1"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
  assume_role {
    role_arn = "arn:aws:iam::110807749034:role/student-deploy"
  }
}

data "aws_caller_identity" "current" {}
