output "bucket_name" {
  description = "Generated S3 bucket name"
  value       = aws_s3_bucket.demo.id
}

output "aws_region" {
  description = "AWS region used by the deployment"
  value       = var.aws_region
}
