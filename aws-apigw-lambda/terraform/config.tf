
terraform {
  required_version = "~> 0.12.20"

  # backend "s3" {}
}

provider "aws" {
  region  = "ap-northeast-1"
  profile = var.aws_profile
  version = "~> 2.45"
}

provider "archive" {
  version = "~> 1.3"
}
