# Create S3 Bucket using count
resource "aws_s3_bucket" "example_bucket" {
  count = 2
  bucket = var.bucket_names[count.index]
  tags = var.tags
}

#Create S3 Bucket using for_each
resource "aws_s3_bucket" "example_bucket_set" {
  for_each = var.bucket_name_set
  bucket = each.value
  tags = var.tags
  depends_on = [ aws_s3_bucket.example_bucket ]
}