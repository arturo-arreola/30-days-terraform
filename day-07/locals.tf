locals {
  env                = var.r2r-prefix
  bucket_name        = "${local.env}-example-bucket-12345"
  vpc_name           = "${local.env}-example-vpc"
  ec2_name           = "${local.env}-example-ec2-instance"
  aws_security_group = "${local.env}-allow-tls-sg"
}

locals {
  tags = merge(var.tags, {
    Name        = local.ec2_name,
    Environment = var.environment
  })
}