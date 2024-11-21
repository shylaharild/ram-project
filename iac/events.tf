# EventBridge Rule and Permissions
resource "aws_cloudwatch_event_rule" "daily_6pm" {
  name                = "daily_6pm"
  description         = "Triggers at 6pm daily"
  schedule_expression = "cron(0 18 * * ? *)"  # 6 PM UTC daily
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.daily_6pm.name
  target_id = "lambda"
  arn       = aws_lambda_function.check_temp_resources.arn
}
