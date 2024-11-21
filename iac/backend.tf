terraform {
  required_version = ">= 1.5.4"

  backend "s3" {
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.21.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.1"
    }
  }
}
