# Output the VPC and EC2 instance IDs
output "vpc_id" {
  value = aws_vpc.example_vpc.id
}

output "ec2_id" {
  value = aws_instance.example_instance.id
}