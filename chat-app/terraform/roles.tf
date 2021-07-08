resource "aws_iam_role" "lambda-role" {
  name = "${var.app-name}-lambda"
  assume_role_policy = data.aws_iam_policy_document.LambdaAssumeRole.json
}

resource "aws_iam_role_policy" "lambda-role-log-group-access-policy" {
  name = "LambdaLogGroupAccess"
  policy = data.aws_iam_policy_document.LambdaLogGroupAccess.json
  role = aws_iam_role.lambda-role.id
}
