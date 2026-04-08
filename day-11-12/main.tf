resource "aws_s3_bucket" "example_bucket" {
  bucket = local.formatted_bucket_name
  tags   = local.merged_tags
}
