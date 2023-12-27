provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      name = "lambda-api-gateway"
    }
  }
}

locals{
  jarKeyName="java_jar"
  jarFileName="AwsLamda.jar"
  
  nodeKeyName="node_zip"
  nodeSourceFile="AwsLambdaNode"
  nodeZipFileName="AwsLambdaNode.zip"
  
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

resource "aws_s3_object" "s3_lambda_java" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = local.jarKeyName
  source = local.jarFileName

  etag = filemd5(local.jarFileName)
}

data "archive_file" "archive" {
  type = "zip"
  source_dir  = format("${path.module}/%s",local.nodeSourceFile)
  output_path = format("${path.module}/%s",local.nodeZipFileName)
}

resource "aws_s3_object" "s3_lambda_node" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = local.nodeKeyName
  source = data.archive_file.archive.output_path

  etag = filemd5(data.archive_file.archive.output_path)
}