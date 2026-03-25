# Create EC2 Instance
resource "aws_instance" "example_instance" {
  count                       = var.instance_count
  ami                         = "ami-0c94855ba95c71c99"       # Amazon Linux 2 AMI
  instance_type               = var.allowed_vm_types[0]       # Using the first allowed VM type from the list
  monitoring                  = var.config.monitoring_enabled # Using the monitoring_enabled value from the config object variable
  associate_public_ip_address = var.associate_public_ip
  region                      = var.config.region # Using the region from the config object variable
  tags                        = var.tags
  #region                      = tolist(var.allowed_regions)[0] # Using the first allowed region from the set
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"

  tags = merge(local.tags, {
    Description = "allow_tls"
    Name        = local.aws_security_group
  })
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = var.cidr_block[0]     # Using the first CIDR block from the list
  from_port         = var.ingress_values[0] # Using the first value from the tuple for from_port
  ip_protocol       = var.ingress_values[1] # Using the second value from the tuple for ip_protocol
  to_port           = var.ingress_values[2] # Using the third value from the tuple for to_port
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

