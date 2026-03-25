# Variables
variable "environment" {
  default = "Dev"
  type    = string
}

variable "r2r-prefix" {
  default = "r2r"
  type    = string
}

variable "instance_count" {
  default = 1
  type    = number
}

variable "monitoring_enabled" {
  default = true
  type    = bool
}

variable "associate_public_ip" {
  default = true
  type    = bool
}

variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = list(string)
  default     = ["10.0.0.0/8", "192.168.0.0/16", "172.16.0.0/16"]
}

variable "allowed_vm_types" {
  description = "List of allowed VM types"
  type        = list(string)
  default     = ["t2.micro", "t2.small", "t2.medium"]
}

variable "allowed_regions" {
  description = "List of allowed regions"
  type        = set(string)
  default     = ["us-east-1", "us-west-1", "eu-west-1", "eu-west-1"]
}

variable "tags" {
  type = map(string)
  default = {
    CreatedBy = "Terraform"
  }
}

variable "ingress_values" {
  type    = tuple([number, string, number])
  default = [443, "tcp", 443]
}

variable "config" {
  type = object({
    region             = string,
    monitoring_enabled = bool,
    instance_count     = number
  })
  default = {
    region             = "us-east-1",
    monitoring_enabled = true,
    instance_count     = 1
  }
}