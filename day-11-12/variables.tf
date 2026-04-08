# Variables
variable "project_name" {
  default = "Project Alpha Resource"
  type    = string
}

variable "r2r_prefix" {
  default = "r2r"
  type    = string
}

variable "environment" {
  default = "dev"
  type    = string
}

variable "default_tags" {
  default = {
    company    = "TechCorp"
    managed_by = "DevOps"
  }
}

variable "environment_tags" {
  default = {
    Environment = "Development"
    CostCenter  = "12345"
  }
}

variable "allowed_ports" {
  default = "80,443,8080"
}

variable "instance_size" {
  default = {
    dev     = "t3.micro"
    staging = "t3.small"
    prod    = "t3.medium"
  }
}

variable "instance_type" {
  default = "t2.micro"
  validation {
    condition     = length(var.instance_type) >= 2 && length(var.instance_type) <= 20
    error_message = "Instance type must be between 2 and 20 characters long."
  }
  validation {
    condition     = can(regex("^t[2-3]+\\.", var.instance_type))
    error_message = "Instance type must start with 't2.' or 't3.'."
  }
}

variable "backup_name" {
  default = "dialy_backup"
  validation {
    condition     = endswith(var.backup_name, "_backup")
    error_message = "Backup name must end with '_backup'."
  }
}

variable "monthly_costs" {
  default = [-50, 100, 150, -20, 200]
}
