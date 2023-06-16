provider "aws" {
  region     = var.region
  access_key = "AKIATNHOIVSE6EDLHZT4"
  secret_key = "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"

}

provider "archive" {}

data "archive_file" "zip" {
  type        = "zip"
  source_file = "welcome.py"
  output_path = "welcome.zip"
}

data "aws_iam_policy_document" "policy" {
  statement {
    sid    = ""
    effect = "Allow"
    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.policy.json
}

resource "aws_lambda_function" "lambda" {
  function_name = "welcome"
  filename      = data.archive_file.zip.output_path
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "welcome.lambda_handler"
  runtime       = "python3.8"
}