resource "aws_lambda_function" "lambda_java" {
  function_name = "t_lambda_java"
  role = aws_iam_role.t_iam_role.arn
  runtime = "java11"
  handler = "com.lambda.SimpleHandler::handleRequest"
  filename = local.jarFileName
  source_code_hash = filebase64sha256(local.jarFileName)
  memory_size = 256
  timeout = 60
}

resource "aws_lambda_function" "lambda_node" {
  function_name = "t_lambda_node"
  role = aws_iam_role.t_iam_role.arn
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