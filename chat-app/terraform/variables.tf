variable "account" {
    description = "AWS Account ID set via commandline"
    type = string
}

variable "app-name" {
    description = "name of the lambda function"
    type = string
    default = "chat-app"
}

variable "region" {
    description = "AWS to deploy to"
    type = string
    default = "eu-central-1"
}

variable "deploy-bucket-name" {
    description = "S3 bucket used to deploy terraform state and other files"
    type = string
    default = "kabatrinkerlearn-deploy"
}

variable "terraform-role-name" {
    description = "arn of the role used to execute terraform"
    type = string
    default = "student-deploy"
}