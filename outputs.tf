output "bucket_name" {
  description = "Generated S3 bucket name"
  value       = aws_s3_bucket.demo.id
}

output "aws_region" {
  description = "AWS region used by the deployment"
  value       = var.aws_region
}

output "ec2_instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.demo.id
}

output "ec2_public_ip" {
  description = "EC2 public IP address"
  value       = aws_instance.demo.public_ip
}

output "ec2_public_url" {
  description = "URL to access nginx on EC2"
  value       = "http://${aws_instance.demo.public_dns}"
}
