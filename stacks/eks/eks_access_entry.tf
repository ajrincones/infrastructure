resource "aws_eks_access_entry" "admins_conexa" {
  cluster_name      = aws_eks_cluster.zeus.name
  principal_arn     = var.iam_admin_arn_conexa
  kubernetes_groups = ["masters"]
  type              = "STANDARD"
}

resource "aws_eks_access_policy_association" "admins_conexa" {
  cluster_name  = aws_eks_cluster.zeus.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = var.iam_admin_arn_conexa

  access_scope {
    type = "cluster"
  }
}