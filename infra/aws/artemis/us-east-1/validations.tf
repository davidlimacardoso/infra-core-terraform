resource "null_resource" "validate_workspace" {
  lifecycle {
    precondition {
      condition     = contains(["dev", "stg", "prod"], terraform.workspace)
      error_message = "Invalid environment workspace! Your workspace must be one of: dev, stg or prd."
    }
  }
}

resource "null_resource" "check_match_workspace_environment" {
  lifecycle {
    precondition {
      condition     = var.env == terraform.workspace
      error_message = "The workspace environment must match the value of the 'env' variable."
    }
  }
}