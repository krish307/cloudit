data "aws_caller_identity" "current" {}

resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]

  tags = {
    Name      = "GitHub-Actions-OIDC"
    Project   = "CloudIt"
    ManagedBy = "Terraform"
  }
}

data "aws_iam_policy_document" "github_actions_assume_role" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    principals {
      type = "Federated"

      identifiers = [
        aws_iam_openid_connect_provider.github.arn
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"

      values = [
        "sts.amazonaws.com"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"

      values = [
        "repo:krish307/cloudit:ref:refs/heads/main"
      ]
    }
  }
}

resource "aws_iam_role" "github_actions_ecr" {
  name               = "CloudItGitHubActionsECRRole"
  assume_role_policy = data.aws_iam_policy_document.github_actions_assume_role.json

  tags = {
    Project   = "CloudIt"
    ManagedBy = "Terraform"
  }
}

data "aws_iam_policy_document" "github_actions_ecr" {
  statement {
    sid    = "ECRAuthentication"
    effect = "Allow"

    actions = [
      "ecr:GetAuthorizationToken"
    ]

    resources = ["*"]
  }

  statement {
    sid    = "PushCloudItImages"
    effect = "Allow"

    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart",
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer"
    ]

    resources = [
      aws_ecr_repository.cloudit.arn
    ]
  }
}

resource "aws_iam_role_policy" "github_actions_ecr" {
  name   = "CloudItECRPushPolicy"
  role   = aws_iam_role.github_actions_ecr.id
  policy = data.aws_iam_policy_document.github_actions_ecr.json
}