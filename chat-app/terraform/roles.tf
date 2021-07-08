resource "aws_iam_role" "lambda-role" {
  name = "${var.app-name}-lambda"
  assume_role_policy = data.aws_iam_policy_document.LambdaAssumeRole.json
}

resource "aws_iam_role_policy_attachment" "lambda-role-log-group-access-policy" {
  policy_arn = aws_iam_policy.lambda-log-group-access.arn
  role = aws_iam_role.lambda-role.id
}

resource "aws_iam_role_policy_attachment" "lambda-role-dynamodb-policy" {
  policy_arn = aws_iam_policy.lambda-dynamodb-access.arn
  role = aws_iam_role.lambda-role.id
}

resource "aws_iam_role_policy_attachment" "lambda-role-apigateway-websocket-policy" {
  policy_arn = aws_iam_policy.lambda-apigateway-websocket-access.arn
  role = aws_iam_role.lambda-role.id
}

resource "aws_iam_role" "apigateway-cloudwatch-log-role" {
  name = "apigateway-log"
  assume_role_policy = data.aws_iam_policy_document.ApiGatewayAssumeRole.json
}

resource "aws_iam_role_policy_attachment" "lambda-role-apigateway-websocket-policy" {
  policy_arn = aws_iam_policy.apigateway-logging-access.arn
  role = aws_iam_role.apigateway-cloudwatch-log-role.id
}
