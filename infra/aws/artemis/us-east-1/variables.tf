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

variable "eks_cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "create_vpc" {
  description = "Controls if VPC should be created (it affects almost all resources)"
  type        = bool
  default     = true
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "mars-vpc"
}

variable "vpc_id" {
  default     = ""
  type        = string
  description = "VPC ID to associate with EKS Cluster"
}

variable "private_subnets" {
  default     = ["172.20.1.0/24", "172.20.2.0/24", "172.20.3.0/24"]
  type        = list(string)
  description = "Private Subnets VPC for EKS Cluster"
}

variable "public_subnets" {
  default     = ["172.20.4.0/24", "172.20.5.0/24", "172.20.6.0/24"]
  type        = list(string)
  description = "Public Subnets VPC for EKS Cluster"
}

variable "vpc_cdir_block" {
  default     = "172.20.0.0/16"
  type        = string
  description = "CIDR block for VPC"
}

variable "domain_name" {
  default     = "jupter.xyz"
  type        = string
  description = "The domain name for which the certificate should be issued."
}

data "aws_caller_identity" "current" {}

data "aws_availability_zones" "available" {}
