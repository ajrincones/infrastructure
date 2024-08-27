data "aws_iam_policy_document" "eks_cluster_autoscaler_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:cluster-autoscaler"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "eks_cluster_autoscaler" {
  assume_role_policy = data.aws_iam_policy_document.eks_cluster_autoscaler_assume_role_policy.json
  name               = "eks-cluster-autoscaler"

  tags = {
    Stack = local.Stack
  }
}

resource "aws_iam_policy" "eks_cluster_autoscaler" {
  name = "eks-cluster-autoscaler"

  policy = jsonencode({
    Statement = [{
      Action = [
        "autoscaling:DescribeAutoScalingGroups",
        "autoscaling:DescribeAutoScalingInstances",
        "autoscaling:DescribeLaunchConfigurations",
        "autoscaling:DescribeTags",
        "ec2:DescribeImages",
        "ec2:DescribeInstanceTypes",
        "ec2:DescribeLaunchTemplateVersions",
        "ec2:GetInstanceTypesFromInstanceRequirements",
        "eks:DescribeNodegroup",
      ]
      Effect   = "Allow"
      Resource = ["*"]
      },
      {
        Action = [
          "autoscaling:SetDesiredCapacity",
          "autoscaling:TerminateInstanceInAutoScalingGroup"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:autoscaling:${var.AWS_REGION}:${var.AWS_ACCOUNT}:autoScalingGroup:*:autoScalingGroupName/eks-${aws_eks_node_group.nodeA.node_group_name}*",
          "arn:aws:autoscaling:${var.AWS_REGION}:${var.AWS_ACCOUNT}:autoScalingGroup:*:autoScalingGroupName/eks-${aws_eks_node_group.nodeB.node_group_name}*"
        ]
      }
    ]
    Version = "2012-10-17"
  })

  tags = {
    Stack = local.Stack
  }
}

resource "aws_iam_role_policy_attachment" "eks_cluster_autoscaler_attach" {
  role       = aws_iam_role.eks_cluster_autoscaler.name
  policy_arn = aws_iam_policy.eks_cluster_autoscaler.arn
}

