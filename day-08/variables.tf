# Variables
variable "environment" {
  default = "Dev"
  type    = string
}

variable "r2r-prefix" {
  default = "r2r"
  type    = string
}

variable "tags" {
  type = map(string)
  default = {
    "Environment" = "Dev"
    "Owner"       = "R2R Team"
    "Project"     = "30 Days of Terraform"
  }
}

variable "bucket_names" {
  type = list(string)
  default = [
    "r2r-example-bucket-03062025-1",
    "r2r-example-bucket-03062025-2"
  ]
}

variable "bucket_name_set" {
  type = set(string)
  default = [
    "r2r-example-bucket-03062025-01",
    "r2r-example-bucket-03062025-02"
  ]
}