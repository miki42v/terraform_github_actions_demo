resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}

resource "aws_s3_bucket" "demo" {
  bucket_prefix = "${var.project_name}-${random_string.suffix.result}-"

  tags = {
    Name        = var.project_name
    Environment = "demo"
    ManagedBy   = "Terraform"
  }
}

resource "aws_s3_bucket_versioning" "demo" {
  bucket = aws_s3_bucket.demo.id

  versioning_configuration {
    status = "Enabled"
  }
}

# -------------------------------------------------------------------
# EC2 INSTANCE
# -------------------------------------------------------------------

# Get the latest Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Security group - allow SSH (port 22) and HTTP (port 80) inbound
resource "aws_security_group" "demo_ec2" {
  name_prefix = "${var.project_name}-ec2-sg-"
  description = "Demo EC2 security group"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "${var.project_name}-ec2-sg"
    ManagedBy = "Terraform"
  }
}

# EC2 Instance (t2.micro = free tier eligible)
resource "aws_instance" "demo" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.demo_ec2.id]

  # Install nginx on start
  user_data = <<-EOF
              #!/bin/bash
              dnf install -y nginx
              systemctl enable nginx
              systemctl start nginx
              EOF

  tags = {
    Name        = "${var.project_name}-ec2"
    Environment = "demo"
    ManagedBy   = "Terraform"
  }
}




