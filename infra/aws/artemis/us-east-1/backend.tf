terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.81.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.3"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.6"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.35.1"
    }

  }

  backend "s3" {
    bucket         = "infra-core-terrform-0836"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "infra_core_terraform_lock"
  }

}
