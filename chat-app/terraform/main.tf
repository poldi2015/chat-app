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
  region = var.region
  assume_role {
    role_arn = "arn:aws:iam::${var.account}:role/${var.terraform-role-name}"
  }
}

data "aws_caller_identity" "current" {}

locals {
  build-path = "${path.module}/build"
}