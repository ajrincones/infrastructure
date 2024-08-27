resource "helm_release" "prometheus" {
  name            = "prometheus"
  repository      = "https://prometheus-community.github.io/helm-charts"
  chart           = "prometheus"
  namespace       = "default"
  version         = "25.25.0"
  cleanup_on_fail = true

  values = [
    file("${path.module}/values.yaml")
  ]
}

# --> agregar storageClassName en values desde lens