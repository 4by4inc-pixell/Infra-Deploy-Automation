resource "kubernetes_storage_class" "efs_prefect" {
  metadata {
    name = "efs-prefect-sc"
    annotations = {
      "storageclass.kubernetes.io/is-default-class" = "false"
    }
  }

  storage_provisioner = "efs.csi.aws.com"

  parameters = {
    fileSystemId      = var.efs_id         # Terraform 변수로 전달
    provisioningMode  = "efs-ap"
    directoryPerms    = "777"
    uid               = "1001"
    gid               = "1001"
  }

  reclaim_policy        = "Delete"
  volume_binding_mode   = "Immediate"
  allow_volume_expansion = true
}