locals {
  hosting-bucket-name = "${var.account}-chat-app"
  frontend-path = "${path.module}/../src/frontend"
}

data "aws_iam_policy_document" "hosting-bucket-policy" {
  statement {
    sid = "HostingBucketGetAccess"
    effect = "Allow"
    principals {
      identifiers = ["*"]
      type = "AWS"
    }
    actions = [
      "s3:GetObject"
    ]
    resources = [
      "arn:aws:s3:::${local.hosting-bucket-name}",
      "arn:aws:s3:::${local.hosting-bucket-name}/*"
    ]
  }
}

resource "aws_s3_bucket" "hosting-bucket" {
  bucket = local.hosting-bucket-name
  acl = "public-read"
  policy = data.aws_iam_policy_document.hosting-bucket-policy.json

  force_destroy = true

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  tags = {
    Source = "chat-app"
  }
}

resource "aws_s3_bucket_object" "hosting-bucket-content-html" {
  bucket = aws_s3_bucket.hosting-bucket.id
  for_each = toset(fileset(local.frontend-path, "*.html"))
  key = each.key
  source = "${local.frontend-path}/${each.key}"
  content_type = "text/html"
}

resource "aws_s3_bucket_object" "hosting-bucket-content-css" {
  bucket = aws_s3_bucket.hosting-bucket.id
  for_each = toset(fileset(local.frontend-path, "*.css"))
  key = each.key
  source = "${local.frontend-path}/${each.key}"
  content_type = "text/css"
}

resource "aws_s3_bucket_object" "hosting-bucket-content-js" {
  bucket = aws_s3_bucket.hosting-bucket.id
  for_each = toset(fileset(local.frontend-path, "*.js"))
  key = each.key
  source = "${local.frontend-path}/${each.key}"
  content_type = "text/javascript"
}

resource "aws_s3_bucket_object" "hosting-bucket-content-gif" {
  bucket = aws_s3_bucket.hosting-bucket.id
  for_each = toset(fileset(local.frontend-path, "*.gif"))
  key = each.key
  source = "${local.frontend-path}/${each.key}"
  content_type = "image/gif"
}

resource "aws_s3_bucket_object" "hosting-bucket-content-backend-url" {
  bucket = aws_s3_bucket.hosting-bucket.id
  key = "backend_url.js"
  content = "export let backendURL=\"${aws_apigatewayv2_stage.web-socket-stage.invoke_url}\"\n"
  content_type = "text/javascript"
  depends_on = [aws_apigatewayv2_stage.web-socket-stage]
}