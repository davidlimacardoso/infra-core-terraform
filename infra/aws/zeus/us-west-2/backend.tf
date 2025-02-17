terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.81.0"
    }
  }

  backend "s3" {
    bucket = "infra-core-terraform-0837"
    key    = "state/us-west-2/terraform.tfstate"
    region = "us-east-1"
  }

}
