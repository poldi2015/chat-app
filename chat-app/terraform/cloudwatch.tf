resource "aws_cloudwatch_log_group" "lambda-log-group" {
  name = "/aws/lambda/${var.app-name}"
}
