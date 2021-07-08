variable "account" {
    description = "AWS Account ID set via commandline"
    type = string
}

variable "app-name" {
    description = "name of the lambda function"
    type = string
    default = "chatapp"
}