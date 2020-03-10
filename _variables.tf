variable "org_name" {
  description = "Name for this organization (not actually used in API call)"
}

variable "s3_days_until_glacier" {
  default     = 90
  description = "How many days before transitioning files to Glacier"
}
