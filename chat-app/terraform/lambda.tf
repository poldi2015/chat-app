locals {
  layers-path = "${path.module}/../layers"
  layers-zip-path = "${local.build-path}/layers.zip"
}

#
# Dependencies package
#

resource "null_resource" "lambda-nodejs-layer" {
  provisioner "local-exec" {
    working_dir = "${local.layers-path}/nodejs"
    command = "npm install"
  }

  triggers = {
    rerun_every_time = uuid()
  }
}

data "archive_file" "lambda-nodejs-layer-package" {
  type = "zip"
  source_dir = local.layers-path
  output_path = local.layers-zip-path

  depends_on = [ null_resource.lambda-nodejs-layer]
}

resource "aws_lambda_layer_version" "lambda-nodejs-layer-version" {
  layer_name = "layers"
  filename = local.layers-zip-path
  source_code_hash = data.archive_file.lambda-nodejs-layer-package.output_base64sha256
  compatible_runtimes = ["nodejs12.x"]
}

#
# Lambda function package
#

module "functions" {
  source = "./lambda-function"
  for_each = toset(["onconnect","ondisconnect","sendmessage"])
  depends_on = [aws_cloudwatch_log_group.lambda-log-group]

  app-name = var.app-name
  function-name = each.key
  layer-arn = aws_lambda_layer_version.lambda-nodejs-layer-version.arn
  role-arn = aws_iam_role.lambda-role.arn
  dynamodb-table-name = "Wasinet"
  region = var.region
}