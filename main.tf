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




