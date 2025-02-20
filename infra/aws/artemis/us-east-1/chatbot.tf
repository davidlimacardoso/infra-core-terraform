# References:
# https://docs.aws.amazon.com/chatbot/latest/adminguide/slack-setup.html#slack-client-setup
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/chatbot_slack_channel_configuration

resource "aws_chatbot_slack_channel_configuration" "slack" {
  configuration_name    = "devops_channel"
  iam_role_arn          = aws_iam_role.chatbot_channel_role.arn
  slack_channel_id      = "C08E66DDMRT"
  slack_team_id         = "T05CU170BHS"
  guardrail_policy_arns = [aws_iam_policy.guardrail.arn]
  sns_topic_arns        = [aws_sns_topic.aws_chatbot_slack.arn]

  tags = {
    Name          = "devops_channel"
    ChatbotConfig = "Slack"
    Env           = var.env
  }
}

resource "aws_sns_topic" "aws_chatbot_slack" {
  name = "aws-devops-slack-channel"
}

resource "aws_iam_role" "chatbot_channel_role" {
  name = "chatbot_channel_role"

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "chatbot.amazonaws.com"
          },
          "Action" : "sts:AssumeRole"
        }
      ]
    }
  )
}

resource "aws_iam_role_policy" "chatbot_channel_policy" {
  name = "chatbot_channel_policy"
  role = aws_iam_role.chatbot_channel_role.id

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : [
            "sns:Subscribe",
          ],
          "Effect" : "Allow",
          "Resource" : aws_sns_topic.aws_chatbot_slack.arn
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "logs:PutLogEvents",
            "logs:CreateLogStream",
            "logs:DescribeLogStreams",
            "logs:CreateLogGroup",
            "logs:DescribeLogGroups"
          ],
          "Resource" : "arn:aws:logs:*:*:log-group:/aws/chatbot/*"
        }
      ]
    }
  )
}

resource "aws_iam_policy" "guardrail" {
  name        = "chatbot_guardrail_policy"
  path        = "/"
  description = "Restrict policy to channel"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "*"
        Effect   = "Deny"
        Resource = "*"
      },
    ]
  })
}