# Run terraform version to check the version

terraform {
  required_version = "~> 0.12.21"

  # backend "s3" {
  #   terraform init -backend-config xxx_backend.tfvars
  # }
}

provider "aws" {
  region  = "ap-northeast-1"
  version = "~> 2.38.0"
}

provider "archive" {
  version = "~> 1.3.0"
}

provider "template" {
  version = "~> 2.1.2"
}
