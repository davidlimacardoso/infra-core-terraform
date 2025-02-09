# Infrastructure Core Terraform

This repository contains Terraform configurations for managing core infrastructure resources across multiple environments.

## Overview

This project uses Terraform to manage AWS infrastructure with a workflow automation using GitHub Actions. It supports multiple environments and includes state management using S3 backend with DynamoDB locking.

## Prerequisites

- Terraform v1.8.3
- AWS CLI configured
- GitHub Actions enabled
- Access to AWS with appropriate permissions

## Project Structure
```
.
├── .github
│ └── workflows
│ └── terraform.yml
├── infra
│ ├── destroy_config.json
│ └── envs
│ └── {environment}
│ └── terraform.tfvars
```


## Configuration

### Environment Variables

The following inputs are required for the workflow:

- `environment`: Target environment name
- `aws-assume-role-arn`: AWS IAM role ARN to assume
- `aws-region`: AWS region for deployment
- `aws-statefile-s3-bucket`: S3 bucket for Terraform state storage
- `aws-lock-dynamodb-table`: DynamoDB table for state locking

## Workflow Features

- **State Management**: Remote state storage in S3 with DynamoDB locking
- **Multiple Environments**: Supports different environments using Terraform workspaces
- **Infrastructure Validation**: Includes terraform validate step
- **Conditional Destruction**: Supports infrastructure destruction based on configuration
- **Plan and Apply**: Separated plan and apply steps for better control

## Usage

1. Configure environment-specific variables in `./infra/envs/{environment}/terraform.tfvars`
2. Update destroy configuration in `destroy_config.json` if needed
3. Push changes to trigger the workflow

## Workflow Steps

1. Checkout code
2. Setup Terraform
3. Configure AWS credentials
4. Check destroy configuration
5. Initialize Terraform
6. Validate Terraform configuration
7. Plan or Destroy (based on configuration)
8. Apply changes (if not destroying)

## Security

- Uses OIDC federation for AWS authentication
- Implements workspace isolation for different environments
- Utilizes remote state locking

## Contributing

1. Create a new branch
2. Make your changes
3. Submit a pull request

## State Management

Terraform state is stored remotely with the following configuration:
- Backend: S3
- State file key: Repository name
- Lock table: DynamoDB


## How to get started?
- Create the GitHub Identity Provider in your AWS account
- Create an IAM Role in your AWS account (Minimum permissions for S3 and DynamoDB)
- Create an S3 Bucket in your AWS account (Enable Bucket Versioning)
- Create a table in DynamoDB in your AWS account (PartitionKey with the name "LockID")
- Clone this repository
- Configure the workflow files
- Done! You are now ready to deploy infrastructure on AWS with Terraform via a pipeline

:mag: Download the project and test it yourself in practice.