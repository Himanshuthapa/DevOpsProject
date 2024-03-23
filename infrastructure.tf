code for creating infrastructure:


# Define providers
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region     = "ap-south-1"
  access_key = "AKIAZRJDI7YLXUPDJ"
  secret_key = "ZEnhRj+uPYb+cW1/wcRm7xCUo3B3g/JAP4DsL"
}

data "aws_ami" "linux" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["amazon"]
}

variable "micro_instance_type" {
  description = "EC2 instance type for micro instance"
  default     = "t2.micro"
}

variable "medium_instance_type" {
  description = "EC2 instance type for medium instances"
  default     = "t2.medium"
}

variable "micro_volume_size" {
  description = "Volume size for micro instance (in GB)"
  default     = 8
}

variable "medium_volume_size" {
  description = "Volume size for medium instances (in GB)"
  default     = 20
}

# Create security group allowing all traffic
resource "aws_security_group" "allow_all_traffic" {
  name        = "allow_all_traffic"
  description = "Allow all traffic inbound and outbound"
  
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Allow all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Allow all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#key_pair
resource "aws_key_pair" "demokeypair" {
public_key = file ("/home/ec2-user/.ssh/id_rsa.pub")
}

# Launch EC2 instances
resource "aws_instance" "micro_instance" {
  ami           = data.aws_ami.linux.id
  instance_type = var.micro_instance_type
  key_name = aws_key_pair.demokeypair.id
  count         = 1
  tags = {
    Name = "WorkerNode"
  }

  root_block_device {
    volume_size = var.micro_volume_size
  }

  security_groups = [aws_security_group.allow_all_traffic.name]
}

resource "aws_instance" "medium_instance_1" {
  ami           = data.aws_ami.linux.id
  instance_type = var.medium_instance_type
  key_name = aws_key_pair.demokeypair.id
  count         = 1
  tags = {
    Name = "KubernetesMaster"
  }

  root_block_device {
    volume_size = var.medium_volume_size
  }

  security_groups = [aws_security_group.allow_all_traffic.name]
}

resource "aws_instance" "medium_instance_2" {
  ami           = data.aws_ami.linux.id
  instance_type = var.medium_instance_type
  key_name = aws_key_pair.demokeypair.id
  count         = 1
  tags = {
    Name = "KubernetesSlave"
  }

  root_block_device {
    volume_size = var.medium_volume_size
  }

  security_groups = [aws_security_group.allow_all_traffic.name]
}
