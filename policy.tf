data "aws_iam_policy_document" "policy_document" {
  statement {
    actions   = ["s3:ListAllMyBuckets",
                "s3:ListBucket"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.lambda_bucket.id}"]
    effect = "Allow"
  }
  statement {
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.lambda_bucket.id}/*"]
    effect = "Allow"
  }
}

resource "aws_iam_policy" "iam_policy" {
  name        = "t-lambda-s3-policy"
  description = "My policy"
  policy = data.aws_iam_policy_document.policy_document.json
}

resource "aws_iam_role_policy_attachment" "policy_attachment" {
   for_each = toset([
    aws_iam_policy.iam_policy.arn,
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  ])
  role       = aws_iam_role.t_iam_role.name
  policy_arn = each.value
}