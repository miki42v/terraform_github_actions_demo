# ============================================================
# STATE BOOTSTRAP - Run this ONCE manually before using CI
# Creates the S3 bucket and DynamoDB table for Terraform state
# ============================================================

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  default = "us-east-1"
}

variable "state_bucket_name" {
  description = "Name of the S3 bucket to store Terraform state"
  type        = string
}

variable "lock_table_name" {
  description = "Name of the DynamoDB table for state locking"
  type        = string
  default     = "terraform-state-lock"
}

# S3 bucket to store .tfstate files
resource "aws_s3_bucket" "state" {
  bucket = var.state_bucket_name

  tags = {
    Name      = "Terraform State"
    ManagedBy = "Terraform"
  }
}

resource "aws_s3_bucket_versioning" "state" {
  bucket = aws_s3_bucket.state.id

  versioning_configuration {
    status = "Enabled"  # Keeps history of every state change
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "state" {
  bucket = aws_s3_bucket.state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"  # Encrypt state at rest
    }
  }
}

resource "aws_s3_bucket_public_access_block" "state" {
  bucket                  = aws_s3_bucket.state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# DynamoDB table for state locking
# Prevents two people/pipelines running at the same time
resource "aws_dynamodb_table" "lock" {
  name         = var.lock_table_name
  billing_mode = "PAY_PER_REQUEST"  # No fixed cost, free when idle
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name      = "Terraform State Lock"
    ManagedBy = "Terraform"
  }
}

output "state_bucket_name" {
  value       = aws_s3_bucket.state.id
  description = "Set this as GitHub variable TF_STATE_BUCKET"
}

output "lock_table_name" {
  value       = aws_dynamodb_table.lock.name
  description = "Set this as GitHub variable TF_LOCK_TABLE"
}
