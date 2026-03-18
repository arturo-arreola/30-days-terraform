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
    key          = "day-04/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}





# Create S3 Bucket
resource "aws_s3_bucket" "example_bucket" {
  bucket = "r2r-example-bucket-12345"

  tags = {
    Name        = "My bucket 2.0"
    Environment = "Dev"
  }
}
