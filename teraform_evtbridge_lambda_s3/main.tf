module "metrics_lambda" {
  source = "terraform-aws-modules/lambda/aws"

  # insert the 28 required variables here
  function_name = "metrics-lambda"
  handler       = "app.handler"
  runtime       = var.runtime_python
  source_path   = "${path.module}/src/app.py"

  tags = {
    Name = "metrics-lambda"
  }
}

data "aws_iam_policy" "lambda_basic_execution_role_policy" {
  name = "AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role" "lambda_iam_role" {
  name_prefix         = "EventBridgeLambdaRole-"
  managed_policy_arns = [data.aws_iam_policy.lambda_basic_execution_role_policy.arn]

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
	{
	  "Action": "sts:AssumeRole",
	  "Principal": {
		"Service": "lambda.amazonaws.com"
	  },
	  "Effect": "Allow",
	  "Sid": ""
	}
  ]
}
EOF
}

resource "aws_cloudwatch_event_rule" "event_rule" {
  name                = "metrics-lambda-event-rule"
  description         = "retry scheduled every 2 min"
  schedule_expression = "rate(2 minutes)"
}


resource "aws_cloudwatch_event_target" "target_metrics_lambda" {
  rule = aws_cloudwatch_event_rule.event_rule.name
  arn  = module.metrics_lambda.lambda_function_arn
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  action        = "lambda:InvokeFunction"
  function_name = module.metrics_lambda.lambda_function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.event_rule.arn
}

output "metrics-lambda" {
  value       = module.metrics_lambda.lambda_function_arn
}
