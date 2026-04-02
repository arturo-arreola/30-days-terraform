# Create an EC2 Instance where is explained how to use conditions in Terraform
resource "aws_instance" "example_instance" {
  ami           = "ami-0c94855ba95c71c99" # Amazon Linux 2 AMI
  count         = var.instance_count
  region        = var.config.region
  instance_type = var.environment == "Dev" ?  var.allowed_vm_types[0] : var.allowed_vm_types[1]
  tags          = merge(var.tags, { Name = "r2r-instance" })
}


# Create a Security Group where is explaines how to use dynamic blocks in Terraform
resource "aws_security_group" "example_sg" {
  name        = "example-sg"
  description = "Example security group"
  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port = ingress.value.from_port
      to_port = ingress.value.to_port
      protocol = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
}

# Create a local variable where is explained how to use splat expressions in Terraform
locals {
  all_instance_ids = aws_instance.example_instance[*].id
}

output "instances" {
  value = local.all_instance_ids
}