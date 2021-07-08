locals {
  frontend-path = "${path.module}/../frontend"
}

data "aws_iam_policy_document" "hosting-bucket-policy" {
  statement {
    sid = "HostingBucketGetAccess"
    effect = "Allow"
    principals {
      identifiers = ["*"]
      type = "AWS"
    }
    actions = [ "GetObject"]
    resources = [
      aws_s3_bucket.hosting-bucket.arn,
      "$aws_s3_bucket.hosting-bucket.arn}/*"]
  }
}

resource "aws_s3_bucket" "hosting-bucket" {
  bucket = "kabatrinkerlearn-chat-app"
  acl    = "public-read"
  policy = data.aws_iam_policy_document.hosting-bucket-policy.json

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  logging {
    target_bucket = "kabatrinkerlearn-logging"
    target_prefix = "chat-app-log/"
  }

  tags = {
    Source = "chat-app"
  }
}

resource "aws_s3_bucket_object" "hosting-bucket-content" {
  bucket =aws_s3_bucket.hosting-bucket.id
  for_each = toset(fileset(local.frontend-path,"*.html"))
  key = each.key
  source = "${local.frontend-path}/${each.key}"
}