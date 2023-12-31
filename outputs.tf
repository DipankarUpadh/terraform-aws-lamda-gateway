# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# Output value definitions

output "lambda_bucket_name" {
  description = "Name of the S3 bucket used to store function code."

  value = aws_s3_bucket.lambda_bucket.id
}

output "function_name" {
  description = "Name of the Lambda function."

  value = aws_lambda_function.lambda_java.function_name
}


output "base_url" {
  description = "Base URL for API Gateway stage."

  value = aws_apigatewayv2_stage.stage.invoke_url
}

output "rendered_policy" {
  value = data.aws_iam_policy_document.policy_document.json
}