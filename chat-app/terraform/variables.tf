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
    default = "eu-west-1"
}

variable "terraform-role-name" {
    description = "arn of the role used to execute terraform"
    type = string
    default = "student-deploy"
}