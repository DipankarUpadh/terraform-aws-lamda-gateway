provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      name = "lambda-api-gateway"
    }
  }

}

resource "random_pet" "lambda_bucket_name" {
  prefix = "terraform-functions"
  length = 2
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket = random_pet.lambda_bucket_name.id
}

resource "aws_s3_bucket_ownership_controls" "lambda_bucket" {
  bucket = aws_s3_bucket.lambda_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "lambda_bucket" {
  depends_on = [aws_s3_bucket_ownership_controls.lambda_bucket]

  bucket = aws_s3_bucket.lambda_bucket.id
  acl    = "private"
}

resource "aws_s3_object" "lambda_java" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "AwsLamda.jar"
  source = "AwsLamda.jar"

  etag = filemd5("AwsLamda.jar")
}

locals {
    jar_filename = "AwsLamda.jar"
}

resource "aws_lambda_function" "lambda_java" {
  function_name = "LambdaJava"
  role = aws_iam_role.lambda_exec.arn
  runtime = "Java 11"
  handler = "Basic.handle"
  source_code_hash = base64sha256(filebase64(locals.jar_filename))
  
  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.lambda_java.key
}

resource "aws_cloudwatch_log_group" "lambda_java" {
  name = "/aws/lambda/${aws_lambda_function.lambda_java.function_name}"

  retention_in_days = 30
}

resource "aws_iam_role" "lambda_exec" {
  name = "serverless_lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}