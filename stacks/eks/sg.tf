# Zeus
resource "aws_security_group" "zeus" {
  name        = local.eks_name
  vpc_id      = var.vpc
  description = "Zeus EKS"

  #   ingress {
  #     description = "Public Ingress"
  #     from_port   = 0
  #     to_port     = 0
  #     protocol    = "-1"
  #     cidr_blocks = ["0.0.0.0/0"]
  #   }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = tolist([var.vpc_cidr])
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "kubernetes.io/cluster/Alleata-dev" = "owned"
    Name                                = local.eks_name
    Stack                               = local.Stack
  }
}
