resource "aws_s3_bucket" "loki" {
  bucket = "conexa-loki-storage"

  tags = {
    Stack = local.Stack
  }
}