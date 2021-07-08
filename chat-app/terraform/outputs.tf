output "s3-bucket-url" {
  value = aws_s3_bucket.hosting-bucket.website_endpoint
}

output "apigateway-invoke-url" {
  value = aws_apigatewayv2_stage.web-socket-stage.invoke_url
}