# Remote backend - stores terraform.tfstate in S3 instead of locally
# Values are passed at runtime via -backend-config flags in the workflow
# so no sensitive bucket names are hardcoded in version control

terraform {
  backend "s3" {
    # These values are injected by GitHub Actions via -backend-config flags:
    #   bucket         = TF_STATE_BUCKET  (GitHub variable)
    #   key            = "terraform.tfstate"
    #   region         = AWS_REGION       (GitHub variable)
    #   dynamodb_table = TF_LOCK_TABLE    (GitHub variable)
    #   encrypt        = true
  }
}
