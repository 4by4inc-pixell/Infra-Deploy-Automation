resource "kubectl_manifest" "user_k8s_manifests" {
  for_each = fileset(var.manifests_path, "**/*.yaml")
  yaml_body = templatefile("${var.manifests_path}/${each.value}", var.template_env)
}