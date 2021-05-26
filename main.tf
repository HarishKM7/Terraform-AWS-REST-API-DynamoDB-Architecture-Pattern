terraform {
  required_version = ">= 0.15.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.42.0"
    }
  }
}

provider "aws" {
  profile = "harish.km@systems-plus.com"
  region  = "us-east-1"
}
