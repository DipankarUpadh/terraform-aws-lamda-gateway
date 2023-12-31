data "aws_iam_policy_document" "policy_document" {
  statement {
    actions   = ["s3:ListAllMyBuckets",
				 "s3:GetObject",
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
  name        = "${random_pet.pet_name.id}-policy"
  description = "My test policy"
  policy = data.aws_iam_policy_document.policy_document.json
}

resource "aws_iam_user_policy_attachment" "policy_attachment_1" {
  user       = aws_iam_role.t_iam_role.name
  policy_arn = aws_iam_policy.iam_policy.arn
}

resource "aws_iam_user_policy_attachment" "policy_attachment_2" {
  user       = aws_iam_role.t_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
