resource "helm_release" "prefect" {
  name       = "prefect-server"
  repository = "https://prefecthq.github.io/prefect-helm"
  chart      = "prefect-server"

  namespace  = kubernetes_namespace.prefect.metadata[0].name
  create_namespace = false


  set {
    name  = "ingress.enabled"
    value = "false"
  }
  set {
    name  = "postgresql.primary.persistence.enabled"
    value = "true"
  }
  set {
    name  = "postgresql.primary.persistence.storageClass"
    value = kubernetes_storage_class.efs_prefect.metadata[0].name
  }
  set {
    name  = "postgresql.primary.persistence.size"
    value = "2Gi"
  }
  set {
    name  = "server.uiConfig.prefectUiApiUrl"
    value = "https://${var.domain_url}/api"
  }
}
