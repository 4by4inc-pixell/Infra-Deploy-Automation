resource "kubectl_manifest" "user_k8s_manifests" {
  for_each = fileset(var.manifests_path, "**/*.yaml")
  yaml_body = templatefile("${var.manifests_path}/${each.value}", {
    node_iam_role_name = var.node_iam_role_name
    cluster_name       = var.cluster_name
  })
}