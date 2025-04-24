resource "kubernetes_namespace" "prefect" {
  metadata {
    name = var.namespace
    labels = {
      name = var.namespace
      creator = "terraform"
    }
  }
}