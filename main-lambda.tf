resource "aws_lambda_function" "lambda_java" {
  function_name = "t_lambda_java"
  role = aws_iam_role.lambda_exec.arn
  runtime = "java11"
  handler = "com.lambda.SimpleHandler::handleRequest"
  filename = local.jarFileName
  source_code_hash = filebase64sha256(local.jarFileName)
  memory_size = 256
  timeout = 60
}

resource "aws_lambda_function" "lambda_node" {
  function_name = "t_lambda_node"
  role = aws_iam_role.lambda_exec.arn
  runtime = "nodejs18.x"
  handler = "hello.handler"
  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.s3_lambda_node.key
  source_code_hash = data.archive_file.archive.output_base64sha256
  memory_size = 256
  timeout = 60
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