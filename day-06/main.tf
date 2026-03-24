# Create S3 Bucket
resource "aws_s3_bucket" "example_bucket" {
  bucket = local.bucket_name
  tags = {
    Name        = "${var.r2r-prefix}-bucket"
    Environment = var.environment
  }
}

# Create VPC
resource "aws_vpc" "example_vpc" {
  cidr_block = "10.0.1.0/24"
  tags = {
    Name        = local.vpc_name
    Environment = var.environment
  }
}

# Create EC2 Instance
resource "aws_instance" "example_instance" {
  ami           = "ami-0c94855ba95c71c99" # Amazon Linux 2 AMI
  instance_type = "t2.micro"
  tags = {
    Name        = local.ec2_name
    Environment = var.environment
  }
}

