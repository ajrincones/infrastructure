# NodeA IAM
resource "aws_iam_role" "nodeB" {
  name = "${local.eks_name}-NodeB"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })

  tags = {
    Stack = local.Stack
  }
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy_B" {
  policy_arn = data.aws_iam_policy.AmazonEKSWorkerNodePolicy.arn
  role       = aws_iam_role.nodeB.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy_B" {
  policy_arn = data.aws_iam_policy.AmazonEKS_CNI_Policy.arn
  role       = aws_iam_role.nodeB.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly_B" {
  policy_arn = data.aws_iam_policy.AmazonEC2ContainerRegistryReadOnly.arn
  role       = aws_iam_role.nodeB.name
}

resource "aws_iam_role_policy_attachment" "CloudWatchAgentServerPolicy_nodeB" {
  policy_arn = data.aws_iam_policy.CloudWatchAgentServerPolicy.arn
  role       = aws_iam_role.nodeB.name
}

resource "aws_iam_policy" "nodeB" {
  name = "${local.eks_name}-NodeB"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:*"
        ]
        Resource = ["*"]
      }
    ]
  })

  tags = {
    Stack = local.Stack
  }
}

resource "aws_iam_role_policy_attachment" "nodeB" {
  policy_arn = aws_iam_policy.nodeB.arn
  role       = aws_iam_role.nodeB.name
}