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
    sid = "LambdaLogGroupCreateSid"
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream"
    ]
    resources = [ "arn:aws:logs:*:*:*" ]
  }
  statement {
    sid = "LambdaLogGroupWriteSid"
    effect    = "Allow"
    actions   = ["logs:PutLogEvents"]
    resources = ["arn:aws:logs:*:*:*"]
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
      "${aws_apigatewayv2_api.chat-app-web-socket.execution_arn}/*"
    ]
  }
}

resource "aws_iam_policy" "lambda-apigateway-websocket-access" {
  name = "ApiGatewayWebsocketAccess"
  path = "/"
  description = "Permission to send messages to a WebSocket via ApiGateway"
  policy = data.aws_iam_policy_document.ApiGatewayWebsocketAccess.json
}

data "aws_iam_policy_document" "ApiGatewayLoggingAccess" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents",
      "logs:GetLogEvents",
      "logs:FilterLogEvents"
    ]
    resources = [ "*" ]
  }
}

data "aws_iam_policy_document" "ApiGatewayAssumeRole" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "apigateway-logging-access" {
  name = "ApiGatewayLoggingAccess"
  path = "/"
  description = "Allows ApiGateway to write logs to Cloudwatch"
  policy = data.aws_iam_policy_document.ApiGatewayLoggingAccess.json
}