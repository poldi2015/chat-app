output "function-arn" {
  value = aws_lambda_function.lambda-function.arn
}

output "function-invoke-arn" {
  value = aws_lambda_function.lambda-function.invoke_arn
}