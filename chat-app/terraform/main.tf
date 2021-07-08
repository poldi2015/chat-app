terraform {
  backend "s3" {
    bucket = var.deploy-bucket-name
    key    = "terraform"
    region = var.region
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