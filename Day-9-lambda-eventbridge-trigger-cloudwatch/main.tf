# IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "lambda_eventbridge_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      Effect = "Allow"
      Sid    = ""
    }]
  })
}

# IAM Policy to allow logging to CloudWatch
resource "aws_iam_role_policy_attachment" "lambda_logging" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Package the lambda code manually before apply:
# zip function.zip lambda_function.py
resource "aws_lambda_function" "my_lambda" {
  function_name = "lambda-scheduled"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"
  role          = aws_iam_role.lambda_role.arn
  timeout       = 900
  memory_size   = 128
  filename         = "lambda_function.zip"  # Ensure this file exists
  source_code_hash = filebase64sha256("lambda_function.zip")

  #Without source_code_hash, Terraform might not detect when the code in the ZIP file has changed — meaning your Lambda might not update even after uploading a new ZIP.

#This hash is a checksum that triggers a deployment.
}

# EventBridge (CloudWatch Event) Rule for Schedule
resource "aws_cloudwatch_event_rule" "every_minute" {
  name                = "lambda-every-minute"
  description         = "Triggers Lambda every 1 minute"
  schedule_expression = "rate(1 minute)"
}

# Add Lambda as the target of EventBridge
resource "aws_cloudwatch_event_target" "trigger_lambda" {
  rule      = aws_cloudwatch_event_rule.every_minute.name
  target_id = "lambdaTarget"
  arn       = aws_lambda_function.my_lambda.arn
}

# Allow EventBridge to invoke the Lambda
resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.my_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.every_minute.arn
}
