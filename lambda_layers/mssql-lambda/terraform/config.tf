# Run terraform version to check the version

terraform {
  required_version = "~> 0.12.20"

  # you may need this backend setup
  # terraform init -backend-config xxx_backend.tfvars
  # backend "s3" {}
}

provider "aws" {
  region  = "ap-northeast-1"
  version = "~> 2.48"
}

provider "archive" {
  version = "~> 1.3"
}
