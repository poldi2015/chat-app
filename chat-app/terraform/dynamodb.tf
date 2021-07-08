resource "aws_dynamodb_table" "chat-app-messages" {
  name           = "ChatAppMessages"
  billing_mode = "PAY_PER_REQUEST"
  write_capacity = 2
  read_capacity = 2

  hash_key       = "connectionId"

  attribute {
    name = "connectionId"
    type = "S"
  }

  tags = {
    Source = "chat-app"
  }
}