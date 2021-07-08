variable "app-name" {
  description = "name of the complete app"
  type = string
}

variable "function-name" {
  description = "name of the lambda function. Used as directory name beneath src/ and for generating archive names"
  type = string
}

variable "layer-arn" {
  description = "arn of the lambda layer to use"
  type = string
}

variable "role-arn" {
  description = "arn of the role to assing to the lambda function"
  type = string
}

variable "dynamodb-table-name" {
  description = "Name of the DynamoDB table to access by the lambda function"
  type = string
}

variable "region" {
  description = "AWS region where dynamoDB is deployed"
  type = string
  default = "eu-central-1"
}