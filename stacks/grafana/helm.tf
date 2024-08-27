resource "helm_release" "grafana" {
  name            = "grafana"
  repository      = "https://grafana.github.io/helm-charts"
  chart           = "grafana"
  namespace       = "default"
  version         = var.grafana_version
  cleanup_on_fail = true
  recreate_pods   = true

  values = [
    data.template_file.values.rendered
  ]
}

data "template_file" "values" {
  template = file("${path.module}/values.yaml")

  vars = {
    admin_user            = jsondecode(nonsensitive(data.aws_secretsmanager_secret_version.admin.secret_string)).username
    admin_password        = jsondecode(nonsensitive(data.aws_secretsmanager_secret_version.admin.secret_string)).password
    storage_class_name    = var.storage_class_name
    assertNoLeakedSecrets = false
    smtp_host             = jsondecode(nonsensitive(data.aws_secretsmanager_secret_version.sendgrid.secret_string)).host
    smtp_password         = jsondecode(nonsensitive(data.aws_secretsmanager_secret_version.sendgrid.secret_string)).password
    smtp_user             = jsondecode(nonsensitive(data.aws_secretsmanager_secret_version.sendgrid.secret_string)).user
    smtp_from_addres      = jsondecode(nonsensitive(data.aws_secretsmanager_secret_version.sendgrid.secret_string)).from_address
  }
}