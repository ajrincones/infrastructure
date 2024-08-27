resource "aws_eks_node_group" "nodeA" {
  cluster_name    = aws_eks_cluster.zeus.name
  node_group_name = "${local.eks_name}-NodeA"
  node_role_arn   = aws_iam_role.nodeA.arn
  subnet_ids = [
    var.private_subnet_a
  ]
  ami_type        = "AL2023_ARM_64_STANDARD"
  instance_types  = var.eks_instance_types
  release_version = var.eks_ami_version

  scaling_config {
    desired_size = var.eks_node_a_desired
    max_size     = var.eks_node_a_max
    min_size     = var.eks_node_a_min
  }

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }

  update_config {
    max_unavailable = 1
  }

  labels = {
    node = "NodeA"
  }

  depends_on = [
    aws_eks_cluster.zeus,
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSVPCResourceController,
  ]

  tags = {
    Stack = local.Stack
  }
}

resource "aws_autoscaling_group_tag" "nodeA" {
  for_each = toset(
    [for asg in flatten(
      [for resources in aws_eks_node_group.nodeA.resources : resources.autoscaling_groups]
    ) : asg.name]
  )

  autoscaling_group_name = each.value

  tag {
    key                 = "Name"
    value               = "${local.eks_name}-NodeA"
    propagate_at_launch = true
  }


  depends_on = [
    aws_eks_node_group.nodeA
  ]
}

resource "aws_autoscaling_group_tag" "nodeA_stack" {
  for_each = toset(
    [for asg in flatten(
      [for resources in aws_eks_node_group.nodeA.resources : resources.autoscaling_groups]
    ) : asg.name]
  )

  autoscaling_group_name = each.value

  tag {
    key                 = "Stack"
    value               = local.Stack
    propagate_at_launch = true
  }


  depends_on = [
    aws_eks_node_group.nodeA
  ]
}
