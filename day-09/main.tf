# Create an EC2 Instance
resource "aws_instance" "example_instance" {
  ami           = "ami-0c94855ba95c71c99" # Amazon Linux 2 AMI
  instance_type = var.allowed_vm_types[0] # Using the first allowed VM type from the list
  region        = var.config.region
  tags          = merge(var.tags, { Name = "r2r-instance" })
  lifecycle {
    create_before_destroy = true
    prevent_destroy       = false
  }
}

# Create a launch template
resource "aws_launch_template" "example_launch_template" {
  name_prefix   = "example-launch-template-"
  image_id      = "ami-0c94855ba95c71c99" # Amazon Linux 2 AMI
  instance_type = var.allowed_vm_types[0] # Using the first allowed VM type from the list

  tag_specifications {
    resource_type = "instance"
    tags          = merge(var.tags, { Name = "r2r-launch-template-instance" })
  }
}

# Create an Auto Scaling Group
resource "aws_autoscaling_group" "example_asg" {
  name               = "r2r-app-servers-asg"
  max_size           = 3
  min_size           = 1
  desired_capacity   = 2
  health_check_type  = "EC2"
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
  launch_template {
    id      = aws_launch_template.example_launch_template.id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "r2r-asg-instance"
    propagate_at_launch = true
  }
  lifecycle {
    ignore_changes = [desired_capacity]
  }
}

resource "aws_security_group" "app_sg" {
  name        = "app-security-group"
  description = "Security group for application servers"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP from anywhere"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS from anywhere"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = merge(
    var.tags,
    {
      Name = "App Security Group"
      Demo = "replace_triggered_by"
    }
  )
}

# EC2 Instance that gets replaced when security group changes
resource "aws_instance" "app_with_sg" {
  ami                    = "ami-0c94855ba95c71c99"
  instance_type          = var.allowed_vm_types[0]
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  tags = merge(
    var.tags,
    {
      Name = "App Instance with Security Group"
      Demo = "replace_triggered_by"
    }
  )

  # Lifecycle Rule: Replace instance when security group changes
  # This ensures the instance is recreated with new security rules
  lifecycle {
    replace_triggered_by = [
      aws_security_group.app_sg.id
    ]
  }
}


# Pre-condition and Post-condition example
resource "aws_dynamodb_table" "critical_app_data" {
  name         = "${var.environment}-app-data-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = merge(
    var.tags,
    {
      Name        = "Critical Application Data"
      Demo        = "multiple_lifecycle_rules"
      DataType    = "Critical"
      Environment = var.environment
    }
  )

  # Multiple Lifecycle Rules Combined for Production Protection
  lifecycle {
    # Rule 1: Prevent accidental deletion
    # This protects the table from being destroyed accidentally
    # prevent_destroy = true  # COMMENTED OUT TO ALLOW DESTRUCTION

    # Rule 2: Create new resource before destroying old one
    # Ensures zero downtime if table needs to be recreated
    create_before_destroy = true

    # Rule 3: Ignore changes to certain attributes
    # Allow AWS to manage read/write capacity for auto-scaling
    ignore_changes = [
      # Ignore read/write capacity if using auto-scaling
      # read_capacity,
      # write_capacity,
    ]

    # Rule 4: Validate before creation
    precondition {
      condition     = contains(keys(var.tags), "Environment")
      error_message = "Critical table must have Environment tag for compliance!"
    }

    # Rule 5: Validate after creation
    postcondition {
      condition     = self.billing_mode == "PAY_PER_REQUEST" || self.billing_mode == "PROVISIONED"
      error_message = "Billing mode must be either PAY_PER_REQUEST or PROVISIONED!"
    }
  }
}