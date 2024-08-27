resource "aws_efs_file_system" "zeus" {
  creation_token   = "${local.eks_name}-EFS"
  encrypted        = true
  throughput_mode  = "elastic"
  performance_mode = "generalPurpose"

  #   lifecycle_policy {
  #     transition_to_ia = "AFTER_7_DAYS"
  #   }

  tags = {
    Name  = "${local.eks_name}-EFS"
    Stack = local.Stack
  }
}

resource "aws_efs_mount_target" "private_subnet_a" {
  file_system_id  = aws_efs_file_system.zeus.id
  subnet_id       = var.private_subnet_a
  security_groups = [aws_eks_cluster.zeus.vpc_config[0].cluster_security_group_id]
}

resource "aws_efs_mount_target" "private_subnet_b" {
  file_system_id  = aws_efs_file_system.zeus.id
  subnet_id       = var.private_subnet_b
  security_groups = [aws_eks_cluster.zeus.vpc_config[0].cluster_security_group_id]
}

# Unused AZ
# resource "aws_efs_mount_target" "private_subnet_c" {
#   file_system_id  = aws_efs_file_system.zeus.id
#   subnet_id       = var.private_subnet_c
#   security_groups = [aws_eks_cluster.zeus.vpc_config[0].cluster_security_group_id]
# }

resource "aws_efs_backup_policy" "zeus" {
  file_system_id = aws_efs_file_system.zeus.id

  backup_policy {
    status = "ENABLED"
  }
}
