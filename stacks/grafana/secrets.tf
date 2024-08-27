data "aws_secretsmanager_secret_version" "admin" {
  secret_id = var.grafana_secret_admin
}

data "aws_secretsmanager_secret_version" "sendgrid" {
  secret_id = var.grafana_secret_sendgrid
}


