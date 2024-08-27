# EFS IAM
data "aws_iam_policy_document" "AmazonEKS_EFS_CSI_DriverRole" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringLike"
      variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:efs-csi-*"]
    }

    condition {
      test     = "StringLike"
      variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "efs" {
  name               = "${local.eks_name}-AmazonEKS_EFS_CSI_DriverRole"
  assume_role_policy = data.aws_iam_policy_document.AmazonEKS_EFS_CSI_DriverRole.json

  tags = {
    Stack = local.Stack
  }
}

resource "aws_iam_policy_attachment" "AmazonEKS_EFS_CSI_DriverRole" {
  name       = "AmazonEKS_EFS_CSI_DriverRole"
  roles      = [aws_iam_role.efs.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"
}
