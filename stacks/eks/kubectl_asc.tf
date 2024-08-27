locals {
  asc_name            = "cluster-autoscaler"
  asc_namespace       = "kube-system"
  asc_image           = var.eks_asc_image
  asc_limits_cpu      = "100m"
  asc_limits_memory   = "600Mi"
  asc_requests_cpu    = "100m"
  asc_requests_memory = "600Mi"

}

resource "kubernetes_service_account" "asc" {
  metadata {
    name      = local.asc_name
    namespace = local.asc_namespace

    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.eks_cluster_autoscaler.arn
    }

    labels = {
      "k8s-addon" = "${local.asc_name}.addons.k8s.io"
      "k8s-app"   = local.asc_name
    }
  }
}

resource "kubernetes_cluster_role" "asc" {
  metadata {
    name = local.asc_name

    labels = {
      "k8s-addon" = "${local.asc_name}.addons.k8s.io"
      "k8s-app"   = local.asc_name
    }
  }

  rule {
    api_groups = [""]
    resources  = ["events", "endpoints"]
    verbs      = ["create", "patch"]
  }

  rule {
    api_groups = [""]
    resources  = ["pods/eviction"]
    verbs      = ["create"]
  }

  rule {
    api_groups = [""]
    resources  = ["pods/status"]
    verbs      = ["update"]
  }

  rule {
    api_groups     = [""]
    resources      = ["endpoints"]
    resource_names = ["${local.asc_name}"]
    verbs          = ["get", "update"]
  }

  rule {
    api_groups = [""]
    resources  = ["nodes"]
    verbs      = ["watch", "list", "get", "update"]
  }

  rule {
    api_groups = [""]
    resources = [
      "namespaces",
      "pods",
      "services",
      "replicationcontrollers",
      "persistentvolumeclaims",
      "persistentvolumes"
    ]
    verbs = ["watch", "list", "get"]
  }

  rule {
    api_groups = ["extensions"]
    resources  = ["replicasets", "daemonsets"]
    verbs      = ["watch", "list", "get"]
  }

  rule {
    api_groups = ["policy"]
    resources  = ["poddisruptionbudgets"]
    verbs      = ["watch", "list"]
  }

  rule {
    api_groups = ["apps"]
    resources  = ["statefulsets", "replicasets", "daemonsets"]
    verbs      = ["watch", "list", "get"]
  }


  rule {
    api_groups = ["storage.k8s.io"]
    resources  = ["storageclasses", "csinodes", "csidrivers", "csistoragecapacities"]
    verbs      = ["watch", "list", "get"]
  }


  rule {
    api_groups = ["batch", "extensions"]
    resources  = ["jobs"]
    verbs      = ["get", "list", "watch", "patch"]
  }


  rule {
    api_groups = ["coordination.k8s.io"]
    resources  = ["leases"]
    verbs      = ["create"]
  }


  rule {
    api_groups     = ["coordination.k8s.io"]
    resource_names = ["${local.asc_name}"]
    resources      = ["leases"]
    verbs          = ["get", "update"]
  }
}

resource "kubernetes_role" "asc" {
  metadata {
    name      = local.asc_name
    namespace = local.asc_namespace

    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.eks_cluster_autoscaler.arn
    }

    labels = {
      "k8s-addon" = "${local.asc_name}.addons.k8s.io"
      "k8s-app"   = local.asc_name
    }
  }

  rule {
    api_groups = [""]
    resources  = ["configmaps"]
    verbs      = ["create", "list", "watch"]
  }

  rule {
    api_groups     = [""]
    resources      = ["configmaps"]
    resource_names = ["${local.asc_name}-status", "${local.asc_name}-priority-expander"]
    verbs          = ["delete", "get", "update", "watch"]
  }
}

resource "kubernetes_cluster_role_binding" "asc" {
  metadata {
    name = local.asc_name

    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.eks_cluster_autoscaler.arn
    }

    labels = {
      "k8s-addon" = "${local.asc_name}.addons.k8s.io"
      "k8s-app"   = local.asc_name
    }
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = local.asc_name
  }

  subject {
    kind      = "ServiceAccount"
    name      = local.asc_name
    namespace = local.asc_namespace
  }
}

resource "kubernetes_role_binding" "asc" {
  metadata {
    name      = local.asc_name
    namespace = local.asc_namespace

    labels = {
      "k8s-addon" = "${local.asc_name}.addons.k8s.io"
      "k8s-app"   = local.asc_name
    }
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = local.asc_name
  }

  subject {
    kind      = "ServiceAccount"
    name      = local.asc_name
    namespace = local.asc_namespace
  }
}

resource "kubernetes_deployment" "asc" {
  metadata {
    name      = local.asc_name
    namespace = local.asc_namespace

    labels = {
      "app" = local.asc_name
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = local.asc_name
      }
    }

    template {
      metadata {
        labels = {
          app = local.asc_name
        }

        annotations = {
          "prometheus.io/scrape" = "true"
          "prometheus.io/port"   = 8085
        }
      }

      spec {
        priority_class_name = "system-cluster-critical"

        security_context {
          run_as_non_root = true
          run_as_user     = 65534
          fs_group        = 65534

          seccomp_profile {
            type = "RuntimeDefault"
          }
        }
        service_account_name = local.asc_name

        container {
          image = local.asc_image
          name  = local.asc_name

          resources {
            limits = {
              cpu    = local.asc_limits_cpu
              memory = local.asc_limits_memory
            }
            requests = {
              cpu    = local.asc_requests_cpu
              memory = local.asc_requests_memory
            }
          }
          command = [
            "./${local.asc_name}",
            "--v=4",
            "--stderrthreshold=info",
            "--cloud-provider=aws",
            "--skip-nodes-with-local-storage=false",
            "--expander=least-waste",
            "--node-group-auto-discovery=asg:tag=k8s.io/${local.asc_name}/enabled,k8s.io/${local.asc_name}/${aws_eks_cluster.zeus.id}"
          ]

          volume_mount {
            name       = "ssl-certs"
            mount_path = " /etc/ssl/certs/ca-certificates.crt" #/etc/ssl/certs/ca-bundle.crt for Amazon Linux Worker Nodes
            read_only  = true
          }

          image_pull_policy = "Always"
          security_context {
            allow_privilege_escalation = false
            capabilities {
              drop = ["ALL"]
            }
            read_only_root_filesystem = true
          }
        }
        volume {
          name = "ssl-certs"
          host_path {
            path = "/etc/ssl/certs/ca-bundle.crt"
          }
        }
      }
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_autoscaler_attach
  ]
}