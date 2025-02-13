terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.81.0"
    }
  }

  backend "s3" {
    bucket = "infra-core-terrform-0836"
    key    = "state/sa-east-1/terraform.tfstate"
    region = "us-east-1"
  }

}
