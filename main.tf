resource "aws_s3_bucket" "security" {
  bucket_prefix = var.bucket_prefix
  acl           = "private"
  region        = var.region

  lifecycle {
    prevent_destroy = true
  }

  tags = merge(map("Name","Security Bucket"), var.tags)
}

data "aws_iam_policy_document" "enable_guardduty" {
  statement {
   actions = [
   "guardduty:*"
   ]
    effect = "Allow"
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = ["iam:CreateServiceLinkedRole"]
    resources = [
      "arn:aws:iam::${var.aws_account_id}:role/aws-service-role/guardduty.amazonaws.com/AWSServiceRoleForGuardDuty"
    ]
    condition {
      test     = "StringLike"
      values   = ["guardduty.amazonaws.com"]
      variable = "iam:AWSServiceName"
    }
  }
  statement {
    actions = [
      "iam:PutRolePolicy",
      "iam:DeleteRolePolicy"
    ]
    resources = [
      "arn:aws:iam::${var.aws_account_id}:role/aws-service-role/guardduty.amazonaws.com/AWSServiceRoleForAmazonGuardDuty"
    ]
  }
}

resource "aws_iam_policy" "enable_guardduty" {
  name        = "enable-guardduty-${var.region}"
  path        = "/"
  description = "Allows setup and configuration of GuardDuty"

  policy = data.aws_iam_policy_document.enable_guardduty.json
}

data "aws_iam_policy_document" "security_bucket" {
  statement {
    effect = "Allow"
    actions = [
      "s3:ListAllMyBuckets"
    ]
    resources = [
      "arn:aws:s3:::*"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:*"
    ]
    resources = [
      aws_s3_bucket.security.arn,
      "${aws_s3_bucket.security.arn}/*"
    ]
  }
}

resource "aws_iam_policy" "use_security_bucket" {
  name        = "access-security-bucket-${var.region}"
  path        = "/security/"
  description = "Allows full access to the contents of the security bucket"

  policy = data.aws_iam_policy_document.security_bucket.json
}

resource "aws_iam_group" "guardduty" {
  name = "${var.group_name}-${var.region}"
  path = "/"
}

resource "aws_iam_group_policy_attachment" "enable" {
  group      = aws_iam_group.guardduty.name
  policy_arn = aws_iam_policy.enable_guardduty.arn
}

resource "aws_iam_group_policy_attachment" "useS3bucket" {
  group      = aws_iam_group.guardduty.name
  policy_arn = aws_iam_policy.use_security_bucket.arn
}

resource "aws_iam_group_policy_attachment" "access" {
  group      = aws_iam_group.guardduty.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonGuardDutyFullAccess"
}

resource "aws_iam_group_policy_attachment" "s3readonly" {
  group      = aws_iam_group.guardduty.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_group_membership" "guardduty" {
  name  = "guardduty-admin-members-${var.region}"
  group = aws_iam_group.guardduty.name
  users = var.users
}

resource "aws_guardduty_detector" "guardduty" {
  enable = true
}
