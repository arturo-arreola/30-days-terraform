data "aws_vpc" "vpc_default" {
  filter {
    name   = "tag:Name"
    values = ["default"]
  }
}

data "aws_subnet" "subnet_default" {
  filter {
    name   = "tag:Name"
    values = ["us-east-1-a"]
  }
  vpc_id = data.aws_vpc.vpc_default.id
}

data "aws_ami" "linux_ami_default" {
  owners = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "example_instance" {
  ami = data.aws_ami.linux_ami_default.id
  instance_type = "t2.micro"
  subnet_id = data.aws_subnet.subnet_default.id
  tags = var.instance_tags
}
