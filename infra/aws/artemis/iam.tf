
# resource "aws_iam_openid_connect_provider" "github_actions" {
#   url             = "https://token.actions.githubusercontent.com"
#   client_id_list  = ["sts.amazonaws.com"]
#   thumbprint_list = ["XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"]
# }

data "aws_iam_openid_connect_provider" "github_actions_oidc" {
  arn = "arn:aws:iam::${var.aws_account_id}:oidc-provider/token.actions.githubusercontent.com"
}

##################################
### GitHub Actions IaC Role ###
##################################
resource "aws_iam_role" "github_actions_iac_role" {
  name = "github-actions-iac-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Federated = data.aws_iam_openid_connect_provider.github_actions_oidc.arn
        }
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
            "token.actions.githubusercontent.com:sub" = [
              "repo:davidlimacardoso/infra-core-terraform:ref:refs/heads/main",
              "repo:davidlimacardoso/infra-core-terraform:ref:refs/heads/stage",
              "repo:davidlimacardoso/infra-core-terraform:ref:refs/heads/developer",
              "repo:davidlimacardoso/infra-core-terraform:pull_request"
            ]
          }
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "github_actions_iac_policy" {
  name = "github-actions-iac-policy"
  role = aws_iam_role.github_actions_iac_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "*"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

# resource "aws_iam_role_policy_attachment" "github_actions_iac_policy_attachment" {
#   role       = aws_iam_role.github_actions_iac_role.name
#   policy_arn = aws_iam_role_policy.github_actions_iac_policy.arn
# }
##################################
### GitHub Actions Deploy Role ###
##################################
resource "aws_iam_role" "github_actions_deploy_role" {
  name = "github-actions-deploy-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Federated = data.aws_iam_openid_connect_provider.github_actions_oidc.arn
        }
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
            "token.actions.githubusercontent.com:sub" = [
              "repo:davidlimacardoso/demo-fakeapp-api:ref:refs/heads/main",
              "repo:davidlimacardoso/demo-fakeapp-api:ref:refs/heads/stage",
              "repo:davidlimacardoso/demo-fakeapp-api:ref:refs/heads/developer"
            ]
          }
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "github_actions_deploy_policy" {
  name = "github-actions-deploy-policy"
  role = aws_iam_role.github_actions_deploy_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "cloudformation:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

# resource "aws_iam_role_policy_attachment" "github_actions_deploy_policy_attachment" {
#   role       = aws_iam_role.github_actions_deploy_role.name
#   policy_arn = aws_iam_role_policy.github_actions_deploy_policy.arn
# }