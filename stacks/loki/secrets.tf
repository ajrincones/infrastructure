data "aws_secretsmanager_secret_version" "loki" {
  secret_id = var.loki_keys
}
