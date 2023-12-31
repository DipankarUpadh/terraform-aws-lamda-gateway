resource "aws_iam_user" "user" {
  name = "s3_log_lambda_user"
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "t_iam_role" {
  name = resource.aws_iam_user.name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}