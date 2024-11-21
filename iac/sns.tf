# SNS Topic and Subscription
resource "aws_sns_topic" "notifications" {
  name = "temp-resource-notifications"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.notifications.arn
  protocol  = "email"
  endpoint  = "example@example.com"
}
