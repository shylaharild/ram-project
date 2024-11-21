# Lambda Function
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "lambda_function.py"
  output_path = "lambda_function.zip"
}

resource "aws_lambda_function" "check_temp_resources" {
  function_name = "check_temp_resources"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.8"

  role    = aws_iam_role.lambda_exec_role.arn
  filename = data.archive_file.lambda_zip.output_path

  environment {
    variables = {
      RESOURCE_TYPE = "EC2"
      SNS_TOPIC_ARN = aws_sns_topic.notifications.arn
    }
  }

  depends_on = [aws_iam_role_policy_attachment.lambda_basic_execution]
}

resource "aws_lambda_permission" "allow_event_to_invoke_lambda" {
  statement_id  = "AllowInvocationFromCloudWatchEvents"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.check_temp_resources.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.daily_6pm.arn
}
