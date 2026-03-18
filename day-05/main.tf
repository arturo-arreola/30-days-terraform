terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  # Add remote backend configuration
  backend "s3" {
    bucket       = "r2r-terraform-state"
    key          = "day-05/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Variables
variable "environment" {
  default = "Dev"
  type    = string
}

variable "r2r-prefix" {
  default = "r2r"
  type    = string
}

locals {
  env         = var.r2r-prefix
  bucket_name = "${local.env}-example-bucket-12345"
  vpc_name    = "${local.env}-example-vpc"
  ec2_name    = "${local.env}-example-ec2-instance"
}

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

# Output the VPC and EC2 instance IDs
output "vpc_id" {
  value = aws_vpc.example_vpc.id
}

output "ec2_id" {
  value = aws_instance.example_instance.id
}