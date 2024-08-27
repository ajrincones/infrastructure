resource "helm_release" "aws_load_balancer_controller" {
  name = "aws-load-balancer-controller"

  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  version    = var.eks_load_balancer_controller_version

  set {
    name  = "region"
    value = var.AWS_REGION
  }

  set {
    name  = "vpcId"
    value = var.vpc
  }

  set {
    name  = "clusterName"
    value = aws_eks_cluster.zeus.id
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.aws_load_balancer_controller.arn
  }

  depends_on = [
    aws_eks_cluster.zeus,
    aws_eks_node_group.nodeA,
    aws_eks_node_group.nodeB,
    aws_iam_role_policy_attachment.aws_load_balancer_controller_attach
  ]
}