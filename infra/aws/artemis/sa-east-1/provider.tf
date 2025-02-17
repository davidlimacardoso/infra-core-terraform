provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Environment = var.env
      Terraform   = true
      Managed     = "DevOps"
    }
  }
}