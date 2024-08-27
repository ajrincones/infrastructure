# https://raw.githubusercontent.com/kubernetes-sigs/aws-efs-csi-driver/master/examples/kubernetes/dynamic_provisioning/specs/storageclass.yaml
resource "kubernetes_storage_class_v1" "grafana" {
  metadata {
    name      = "zeus-data"
  }

  storage_provisioner = "efs.csi.aws.com"

  parameters = {
    provisioningMode = "efs-ap"
    fileSystemId     = "${var.efs_id}"
    directoryPerms   = "700"
    # gidRangeStart = "1000" # optional
    # gidRangeEnd = "2000" # optional
    # basePath = "/dynamic_provisioning" # optional
    # subPathPattern =  "${.PVC.namespace}/${.PVC.name}" # optional
    # ensureUniqueDirectory = "true" # optional
    # reuseAccessPoint = "false" # optional
  }
}
