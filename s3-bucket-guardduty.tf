
data "aws_iam_policy_document" "s3_policy_guardduty" {
  statement {
    sid    = "OrgAccounts"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = formatlist("arn:aws:iam::%s:root", data.aws_organizations_organization.selected.accounts[*].id)
    }
    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl"
    ]
    resources = [
      "arn:aws:s3:::${var.org_name}-audit-guardduty/*"
    ]
  }
}

resource "aws_s3_bucket" "guardduty" {
  bucket = "${var.org_name}-audit-guardduty"
  acl    = "private"

  policy = data.aws_iam_policy_document.s3_policy_guardduty.json

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
