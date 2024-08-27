
resource "kubernetes_ingress_v1" "zeus_1" {
  metadata {
    name      = "zeus-1"
    namespace = "default"

    # labels = {
    #   "app" = "alleata"
    # }

    annotations = {
      "kubernetes.io/ingress.class"               = "alb"
      "alb.ingress.kubernetes.io/group.name"      = "zeus-1"
      "alb.ingress.kubernetes.io/tags"            = "Stack=${local.Stack}"
      "alb.ingress.kubernetes.io/target-type"     = "ip"
      "alb.ingress.kubernetes.io/subnets"         = "${var.public_subnet_a}, ${var.public_subnet_b}"
      "alb.ingress.kubernetes.io/scheme"          = "internet-facing"
      "alb.ingress.kubernetes.io/listen-ports"    = jsonencode([{ HTTP = 3000 }, { HTTP = 80 }, { HTTPS = 443 }])
      "alb.ingress.kubernetes.io/ssl-redirect"    = 443
      "alb.ingress.kubernetes.io/certificate-arn" = "${var.grafana_acm}"
    }
  }

  spec {
    default_backend {
      service {
        name = "default"
        port {
          number = 88
        }
      }
    }

    ingress_class_name = "alb"
  }

  depends_on = [
    helm_release.aws_load_balancer_controller
  ]

}


resource "kubernetes_ingress_v1" "zeus_private" {
  metadata {
    name      = "zeus-private"
    namespace = "default"

    annotations = {
      "kubernetes.io/ingress.class"               = "alb"
      "alb.ingress.kubernetes.io/group.name"      = "zeus-private"
      "alb.ingress.kubernetes.io/tags"            = "Stack=${local.Stack}"
      "alb.ingress.kubernetes.io/target-type"     = "ip"
      "alb.ingress.kubernetes.io/subnets"         = "${var.private_subnet_a}, ${var.private_subnet_b}, ${var.private_subnet_c}"
      "alb.ingress.kubernetes.io/scheme"          = "internal"
      "alb.ingress.kubernetes.io/listen-ports"    = jsonencode([{ HTTP = 80 }, { HTTPS = 443 }])
      "alb.ingress.kubernetes.io/ssl-redirect"    = 443
      "alb.ingress.kubernetes.io/certificate-arn" = "${var.ccm_crt}"
    }
  }

  spec {
    default_backend {
      service {
        name = "default"
        port {
          number = 88
        }
      }
    }

    ingress_class_name = "alb"
  }

  depends_on = [
    helm_release.aws_load_balancer_controller
  ]

}
