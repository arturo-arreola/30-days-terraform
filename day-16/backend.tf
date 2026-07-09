# Add remote backend configuration
terraform {
  backend "s3" {
    bucket       = "r2r-terraform-state"
    key          = "day-16/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}