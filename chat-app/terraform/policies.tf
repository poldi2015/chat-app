data "aws_iam_policy_document" "LambdaAssumeRole" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "LambdaLogGroupAccess" {
  statement {
    sid = "LambdaLogGroupAccessSid"
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream"
    ]
    resources = [ aws_cloudwatch_log_group.lambda-log-group.arn ]
  }
  statement {
    effect    = "Allow"
    actions   = ["logs:PutLogEvents"]
    resources = ["${aws_cloudwatch_log_group.lambda-log-group.arn}:*"]
  }
}

resource "aws_iam_policy" "lambda-log-group-access" {
  name        = "LambdaLogGroupAccess"
  path        = "/"
  description = "Permissions to Allow a Lambda to log messages to CloudWwatch Logs"

  policy = data.aws_iam_policy_document.LambdaLogGroupAccess.json
}

data "aws_iam_policy_document" "DynamoDBCrudAccess" {
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:GetItem",
      "dynamodb:DeleteItem",
      "dynamodb:PutItem",
      "dynamodb:Scan",
      "dynamodb:Query",
      "dynamodb:UpdateItem",
      "dynamodb:BatchWriteItem",
      "dynamodb:BatchGetItem",
      "dynamodb:DescribeTable",
      "dynamodb:ConditionCheckItem"
    ]
    resources = [
      aws_dynamodb_table.chat-app-messages.arn,
      "${aws_dynamodb_table.chat-app-messages.arn}/index/*"
    ]
  }
}

resource "aws_iam_policy" "lambda-dynamodb-access" {
  name = "DynamoDBCrudAccess"
  path = "/"
  description = "Permission to allow lambda function CRUD operations to the DynamoDB table"
  policy = data.aws_iam_policy_document.DynamoDBCrudAccess.json
}

data "aws_iam_policy_document" "ApiGatewayWebsocketAccess" {
  statement {
    effect = "Allow"
    actions = [
      "execute-api:ManageConnections"
    ]
    resources = [
      aws_apigatewayv2_api.chat-app-web-socket.execution_arn
    ]
  }
}

resource "aws_iam_policy" "lambda-apigateway-websocket-access" {
  name = "ApiGatewayWebsocketAccess"
  path = "/"
  description = "Permission to send messages to a WebSocket via ApiGateway"
  policy = data.aws_iam_policy_document.ApiGatewayWebsocketAccess.json
}
