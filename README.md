# Terraform GitHub Actions Demo

A beginner-friendly Terraform repo that creates one AWS S3 bucket and runs Terraform through GitHub Actions.

## Project structure

- `.github/workflows/terraform.yml` - CI workflow for Terraform
- `versions.tf` - Terraform and provider versions
- `providers.tf` - AWS provider config
- `variables.tf` - input variables
- `main.tf` - S3 bucket resources
- `outputs.tf` - values shown after apply
- `terraform.tfvars.example` - sample variable values

## What the workflow does

On push or pull request:
1. Checks out the code
2. Installs Terraform
3. Uses AWS credentials from GitHub secrets
4. Runs `terraform init`
5. Runs `terraform fmt -check`
6. Runs `terraform validate`
7. Runs `terraform plan`

On manual run:
- Choose `plan` or `apply`
- `apply` creates the S3 bucket in AWS

## Required GitHub settings

### Repository secrets
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

### Repository variable
- `AWS_REGION` (example: `us-east-1`)

## Local commands

```bash
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan
```

## Important

This demo creates an S3 bucket in your AWS account. Destroy it later with:

```bash
terraform destroy
```
