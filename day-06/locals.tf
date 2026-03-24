locals {
  env         = var.r2r-prefix
  bucket_name = "${local.env}-example-bucket-12345"
  vpc_name    = "${local.env}-example-vpc"
  ec2_name    = "${local.env}-example-ec2-instance"
}