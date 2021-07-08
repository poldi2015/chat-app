resource "aws_dynamodb_table" "chat-app-messages" {
  name           = "ChatAppMessages"
  read_capacity  = 5
  write_capacity = 5

  hash_key       = "connectionId"

  attribute {
    name = "connectionId"
    type = "S"
  }
}