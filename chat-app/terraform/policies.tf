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

