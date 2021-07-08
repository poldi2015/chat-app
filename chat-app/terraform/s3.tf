locals {
  hosting-bucket-name = "kabatrinkerlean-chat-app"
  logging-bucket-name = "kabatrinkerlearn-logging"
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

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  logging {
    target_bucket = local.logging-bucket-name
    target_prefix = "chat-app-log/"
  }

  tags = {
    Source = "chat-app"
  }
}

resource "aws_s3_bucket_object" "hosting-bucket-content" {
  bucket = aws_s3_bucket.hosting-bucket.id
  for_each = toset(fileset(local.frontend-path, "*.html"))
  key = each.key
  source = "${local.frontend-path}/${each.key}"
}