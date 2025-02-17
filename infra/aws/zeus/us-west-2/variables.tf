variable "account_id" {
  description = "AWS account ID"
  type        = string
}

variable "env" {
  description = "The environment for this stack, must be dev, stg or prod"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "S3 bucket name"
  type        = string
}