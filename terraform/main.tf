data "aws_caller_identity" "current" {}

locals {
  datetime_suffix = formatdate("YYYYMMDDhhmmss", timestamp())
  bucket_name     = "my-bucket-${data.aws_caller_identity.current.account_id}-${local.datetime_suffix}"
}

resource "aws_s3_bucket" "hello_world" {
  bucket = local.bucket_name
}
