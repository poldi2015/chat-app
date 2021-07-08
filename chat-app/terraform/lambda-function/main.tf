locals {
  build-path = "${path.root}/build"
  src-path = "${path.root}/../src"
  function-src-path = "${local.src-path}/${var.function-name}"
  lambda-name = "${var.app-name}-${var.function-name}"
  lambda_zip_path = "${local.build-path}/${local.lambda-name}.zip"
}


data "archive_file" "lambda-package" {
  type = "zip"
  source_dir = local.function-src-path
  output_path = local.lambda_zip_path
}

resource "aws_lambda_function" "lambda-function" {
  function_name = var.function-name
  filename = local.lambda_zip_path
  source_code_hash = data.archive_file.lambda-package.output_base64sha256
  handler = "index.handler"
  runtime = "nodejs12.x"
  publish = "true"
  layers = [var.layer-arn]
  role = var.role-arn
}
