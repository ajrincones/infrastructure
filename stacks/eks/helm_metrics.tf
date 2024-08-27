resource "helm_release" "metrics_server" {
  name = "metrics-server"

  repository       = "https://kubernetes-sigs.github.io/metrics-server/"
  chart            = "metrics-server"
  namespace        = "kube-system"
  version          = var.eks_metrics_server_version
  create_namespace = true

  set {
    name  = "apiService.create"
    value = "true"
  }

  set {
    name  = "replicas"
    value = 3
  }
}