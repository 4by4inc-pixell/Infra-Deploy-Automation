resource "helm_release" "kubray_operator" {
  name       = var.name
  namespace  = var.namespace
  repository = "https://ray-project.github.io/kuberay-helm/"
  chart      = "kuberay-operator"
  version    = var.kubray_version # 원하는 버전으로 변경

  create_namespace = true
  values = []
}