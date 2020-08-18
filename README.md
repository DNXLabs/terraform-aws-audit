# terraform-aws-audit

[![Lint Status](https://github.com/DNXLabs/terraform-aws-audit/workflows/Lint/badge.svg)](https://github.com/DNXLabs/terraform-aws-audit/actions)
[![LICENSE](https://img.shields.io/github/license/DNXLabs/terraform-aws-audit)](https://github.com/DNXLabs/terraform-aws-audit/blob/master/LICENSE)

This terraform module creates buckets that save cloudtrail and guardduty logs from all accounts.

The following resources will be created:

- IAM roles
- S3 buckets to save cloudtrail logs
- S3 buckets to save guardduty logs

In addition you have the options to:

 - Set How many days before transitioning files to Glacier.
   - The default value is 90 days
 - Create a read-only role for accessing audit account


<!--- BEGIN_TF_DOCS --->

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.0 |

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| account\_ids | AWS Account IDs under Auditing for the organization | `list` | `[]` | no |
| create\_audit\_role | Create a read-only role for accessing audit account | `bool` | `true` | no |
| idp\_account\_id | Account ID of IDP account (required when create\_audit\_role=true) | `string` | `""` | no |
| master\_account\_id | Master account ID | `any` | n/a | yes |
| org\_name | Name for this organization (not actually used in API call) | `any` | n/a | yes |
| organization\_id | Organization ID for CloudTrail access | `any` | n/a | yes |
| s3\_days\_until\_glacier | How many days before transitioning files to Glacier | `number` | `90` | no |

## Outputs

| Name | Description |
|------|-------------|
| cloudtrail\_s3\_bucket\_id | ID of S3 bucket for cloudtrail |
| guardduty\_s3\_bucket\_id | ID of S3 bucket for guardduty |

<!--- END_TF_DOCS --->

## Author

Module managed by [DNX Solutions](https://github.com/DNXLabs).

## License

Apache 2 Licensed. See [LICENSE](https://github.com/DNXLabs/terraform-aws-audit/blob/master/LICENSE) for full details.
