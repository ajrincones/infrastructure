resource "helm_release" "loki" {
  name            = "loki"
  repository      = "https://grafana.github.io/helm-charts"
  chart           = "loki-distributed"
  namespace       = "default"
  version         = var.loki_version
  cleanup_on_fail = true

  values = [
    data.template_file.loki.rendered
  ]

  depends_on = [
    aws_s3_bucket.loki
  ]
}

data "template_file" "loki" {
  template = file("${path.module}/values_loki.yaml")

  vars = {
    AWS_REGION            = var.AWS_REGION
    s3_bucket_mame        = aws_s3_bucket.loki.id
    aws_access_key_id     = jsondecode(nonsensitive(data.aws_secretsmanager_secret_version.loki.secret_string)).AWS_ACCESS_KEY_ID
    aws_secret_access_key = jsondecode(nonsensitive(data.aws_secretsmanager_secret_version.loki.secret_string)).AWS_SECRET_ACCESS_KEY
  }

  depends_on = [
    aws_s3_bucket.loki
  ]
}