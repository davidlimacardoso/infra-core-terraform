resource "aws_sns_topic" "this" {
  name = "${var.env}-user-updates-topic-auto-merge"
}