data "aws_iam_policy_document" "loki" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:default:loki*"]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "loki" {
  name               = "${local.eks_name}-LokiStorage"
  assume_role_policy = data.aws_iam_policy_document.loki.json

  tags = {
    Stack = local.Stack
  }
}

resource "aws_iam_policy" "loki" {
  name = "${local.eks_name}-LokiStorage"

  policy = jsonencode({
    Statement = [{
      Action = [
        "s3:*"
      ]
      Effect = "Allow"
      Resource = [
        "arn:aws:s3:::${var.loki_bucket_name}",
        "arn:aws:s3:::${var.loki_bucket_name}/*"
      ]
      }
    ]
    Version = "2012-10-17"
  })

  tags = {
    Stack = local.Stack
  }
}

resource "aws_iam_policy_attachment" "loki" {
  name       = "${local.eks_name}-LokiStorage"
  roles      = [aws_iam_role.loki.name]
  policy_arn = aws_iam_policy.loki.arn
}