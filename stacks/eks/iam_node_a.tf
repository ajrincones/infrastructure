# NodeA IAM
resource "aws_iam_role" "nodeA" {
  name = "${local.eks_name}-NodeA"

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

data "aws_iam_policy" "AmazonEKSWorkerNodePolicy" {
  arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

data "aws_iam_policy" "AmazonEKS_CNI_Policy" {
  arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

data "aws_iam_policy" "AmazonEC2ContainerRegistryReadOnly" {
  arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

data "aws_iam_policy" "CloudWatchAgentServerPolicy" {
  arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = data.aws_iam_policy.AmazonEKSWorkerNodePolicy.arn
  role       = aws_iam_role.nodeA.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = data.aws_iam_policy.AmazonEKS_CNI_Policy.arn
  role       = aws_iam_role.nodeA.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = data.aws_iam_policy.AmazonEC2ContainerRegistryReadOnly.arn
  role       = aws_iam_role.nodeA.name
}

resource "aws_iam_role_policy_attachment" "CloudWatchAgentServerPolicy_nodeA" {
  policy_arn = data.aws_iam_policy.CloudWatchAgentServerPolicy.arn
  role       = aws_iam_role.nodeA.name
}


resource "aws_iam_policy" "nodeA" {
  name = "${local.eks_name}-NodeA"

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

resource "aws_iam_role_policy_attachment" "nodeA" {
  policy_arn = aws_iam_policy.nodeA.arn
  role       = aws_iam_role.nodeA.name
}