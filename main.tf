resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = ["sts.amazonaws.com"]
}

data "aws_iam_policy_document" "github_assume_role" {
  statement {
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    actions = ["sts:AssumeRoleWithWebIdentity"]

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values = [
        "repo:${var.organization_name}/${var.repository_name}:*"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "github" {
  name               = "LittleHorseBYOCManager"
  assume_role_policy = data.aws_iam_policy_document.github_assume_role.json
}

data "aws_iam_policy_document" "github_role_policy" {
  statement {
    sid    = "LittleHorseBYOCS3Access"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:ListBucket"
    ]

    resources = [
      "${aws_s3_bucket.terraform_state.arn}/*",
      aws_s3_bucket.terraform_state.arn
    ]
  }

  statement {
    sid    = "LittleHorseBYOCManager"
    effect = "Allow"

    actions = local.byoc_manager_actions

    resources = ["*"]
  }
}

resource "aws_iam_policy" "github" {
  name   = "LittleHorseBYOCManager"
  policy = data.aws_iam_policy_document.github_role_policy.json
}

resource "aws_iam_role_policy_attachment" "github" {
  role       = aws_iam_role.github.id
  policy_arn = aws_iam_policy.github.arn
}
