resource "helm_release" "promtail" {
  name            = "promtail"
  repository      = "https://grafana.github.io/helm-charts"
  chart           = "promtail"
  namespace       = "default"
  version         = "6.16.4"
  cleanup_on_fail = true

  values = [
    file("${path.module}/values_promtail.yaml")
  ]

  depends_on = [
    helm_release.loki
  ]
}