
data "aws_iam_policy_document" "s3_policy_cloudtrail" {
  statement {
    sid    = "CloudTrailAclCheck"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    actions = [
      "s3:GetBucketAcl"
    ]
    resources = [
      "arn:aws:s3:::${var.org_name}-audit-cloudtrail"
    ]
  }

  statement {
    sid    = "CloudTrailWrite"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    actions = [
      "s3:PutObject"
    ]
    resources = formatlist(
      "arn:aws:s3:::${var.org_name}-audit-cloudtrail/AWSLogs/%s/*",
      [var.master_account_id, var.organization_id]
    )
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
}

resource "aws_s3_bucket" "cloudtrail" {
  bucket = "${var.org_name}-audit-cloudtrail"
  acl    = "private"

  policy = data.aws_iam_policy_document.s3_policy_cloudtrail.json

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
      }
    }
  }

  lifecycle_rule {
    id      = "ARCHIVING"
    enabled = true

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
    transition {
      days          = var.s3_days_until_glacier
      storage_class = "GLACIER"
    }
  }
}
