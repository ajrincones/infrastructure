resource "aws_eks_cluster" "zeus" {
  name     = local.eks_name
  role_arn = aws_iam_role.zeus.arn
  version  = var.eks_version

  vpc_config {
    subnet_ids = [
      var.private_subnet_a,
      var.private_subnet_b,
      var.private_subnet_c,
      var.public_subnet_a,
      var.public_subnet_b,
      var.public_subnet_c
    ]
    endpoint_private_access = true
    endpoint_public_access  = true
    public_access_cidrs     = ["0.0.0.0/0"]
    security_group_ids      = [aws_security_group.zeus.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSVPCResourceController,
    aws_iam_role.zeus,
    aws_iam_policy.zeus
  ]

  access_config {
    authentication_mode                         = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = false
  }

  tags = {
    Stack = local.Stack
  }
}

resource "aws_eks_addon" "efs" {
  cluster_name             = aws_eks_cluster.zeus.name
  addon_name               = "aws-efs-csi-driver"
  addon_version            = var.eks_efs_csi_version
  service_account_role_arn = aws_iam_role.efs.arn

  depends_on = [
    aws_eks_node_group.nodeA,
    aws_eks_node_group.nodeB,
    aws_iam_policy_attachment.AmazonEKS_EFS_CSI_DriverRole
  ]

  tags = {
    Stack = local.Stack
  }
}
