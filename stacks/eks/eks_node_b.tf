resource "aws_eks_node_group" "nodeB" {
  cluster_name    = aws_eks_cluster.zeus.name
  node_group_name = "${local.eks_name}-NodeB"
  node_role_arn   = aws_iam_role.nodeB.arn
  subnet_ids = [
    var.private_subnet_b,
  ]
  ami_type        = "AL2023_ARM_64_STANDARD"
  instance_types  = var.eks_instance_types
  release_version = var.eks_ami_version

  scaling_config {
    desired_size = var.eks_node_b_desired
    max_size     = var.eks_node_b_max
    min_size     = var.eks_node_b_min
  }

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }

  update_config {
    max_unavailable = 1
  }

  labels = {
    node = "NodeB"
  }

  depends_on = [
    aws_eks_cluster.zeus,
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy_B,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy_B,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly_B,
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSVPCResourceController,
  ]

  tags = {
    Stack = local.Stack
  }
}

resource "aws_autoscaling_group_tag" "nodeB" {
  for_each = toset(
    [for asg in flatten(
      [for resources in aws_eks_node_group.nodeB.resources : resources.autoscaling_groups]
    ) : asg.name]
  )

  autoscaling_group_name = each.value

  tag {
    key                 = "Name"
    value               = "${local.eks_name}-NodeB"
    propagate_at_launch = true
  }


  depends_on = [
    aws_eks_node_group.nodeB
  ]
}

resource "aws_autoscaling_group_tag" "nodeB_stack" {
  for_each = toset(
    [for asg in flatten(
      [for resources in aws_eks_node_group.nodeB.resources : resources.autoscaling_groups]
    ) : asg.name]
  )

  autoscaling_group_name = each.value

  tag {
    key                 = "Stack"
    value               = local.Stack
    propagate_at_launch = true
  }


  depends_on = [
    aws_eks_node_group.nodeB
  ]
}
