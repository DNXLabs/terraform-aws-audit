
data "aws_iam_policy_document" "s3_policy_apps" {
  count = length(var.s3_regions)

  statement {
    sid    = "CWLogs"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["logs.amazonaws.com"]
    }
    actions = [
      "s3:PutObject"
    ]
    resources = [
      "arn:aws:s3:::${var.org_name}-audit-apps-${var.s3_regions[count.index]}/*"
    ]
  }
  statement {
    sid    = "OrgAccounts"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = formatlist("arn:aws:iam::%s:root", var.account_ids)
    }
    actions = [
      "s3:PutObject"
    ]
    resources = [
      "arn:aws:s3:::${var.org_name}-audit-apps-${var.s3_regions[count.index]}/*"
    ]
  }
  statement {
    sid    = "CWLogsAcl"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["logs.amazonaws.com"]
    }
    actions = [
      "s3:GetBucketAcl"
    ]
    resources = [
      "arn:aws:s3:::${var.org_name}-audit-apps-${var.s3_regions[count.index]}"
    ]
  }
}

resource "aws_s3_bucket" "apps" {
  count  = length(var.s3_regions)
  bucket = "${var.org_name}-audit-apps-${var.s3_regions[count.index]}"
  acl    = "private"

  policy = data.aws_iam_policy_document.s3_policy_apps[count.index].json

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
