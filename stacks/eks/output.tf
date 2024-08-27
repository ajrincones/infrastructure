output "configure_kubectl" {
  description = "Configure kubectl: make sure you have the AWS CLI and kubectl installed on your machine."
  value       = <<-EOT
    To configure kubectl:

    1. Run this command to update your kubeconfig:
       aws eks update-kubeconfig --name ${aws_eks_cluster.zeus.name} --region us-east-1

    2. Verify the connection to your cluster by running:
       kubectl get nodes
  EOT
}

data "aws_ssm_parameter" "eks_ami_release_version" {
  name = "/aws/service/eks/optimized-ami/${aws_eks_cluster.zeus.version}/amazon-linux-2/recommended/release_version"
}

output "nodes_ami" {
  value = <<-EOT
    Current EKS AMI Version: ${aws_eks_node_group.nodeA.release_version}
    Lastest EKS AMI Version: ${nonsensitive(data.aws_ssm_parameter.eks_ami_release_version.value)}
  EOT
}