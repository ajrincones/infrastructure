# EKS
resource "aws_iam_role" "zeus" {
  name = local.eks_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Stack = local.Stack
  }
}

resource "aws_iam_policy" "zeus" {
  name = local.eks_name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:PutLogEvents*"
        ]
        Effect   = "Allow"
        Resource = ["arn:aws:logs:*:*:*"]
      },
      {
        Effect = "Allow",
        Action = [
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling:DescribeLaunchConfigurations",
          "autoscaling:DescribeScalingActivities",
          "autoscaling:DescribeTags",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeLaunchTemplateVersions"
        ]
        Resource = ["*"]
      }
    ]
  })

  tags = {
    Stack = local.Stack
  }
}

data "aws_iam_policy" "AmazonEKSClusterPolicy" {
  arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

data "aws_iam_policy" "AmazonEKSVPCResourceController" {
  arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = data.aws_iam_policy.AmazonEKSClusterPolicy.arn
  role       = aws_iam_role.zeus.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSVPCResourceController" {
  policy_arn = data.aws_iam_policy.AmazonEKSVPCResourceController.arn
  role       = aws_iam_role.zeus.name
}

resource "aws_iam_role_policy_attachment" "zeus" {
  policy_arn = aws_iam_policy.zeus.arn
  role       = aws_iam_role.zeus.name
}
