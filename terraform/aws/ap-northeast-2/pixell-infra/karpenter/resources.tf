resource "helm_release" "karpenter" {
  namespace           = "kube-system"
  name                = "karpenter"
  repository          = "oci://public.ecr.aws/karpenter"
  repository_username = var.aws_token_username
  repository_password = var.aws_token_password
  chart               = "karpenter"
  version             = "1.1.0"
  wait                = false

  values = [
    <<-EOT
    dnsPolicy: Default
    settings:
      clusterName: ${var.cluster_name}
      clusterEndpoint: ${var.cluster_endpoint}
      interruptionQueue: ${var.cluster_queue_name}
    webhook:
      enabled: false
    EOT
  ]
}


resource "kubectl_manifest" "karpenter_node_class" {
  for_each = fileset("${path.module}/../karpenter-manifests", "**/*.class.yaml")

  yaml_body = templatefile("${path.module}/../karpenter-manifests/${each.value}", {
    node_iam_role_name = module.karpenter.node_iam_role_name
    cluster_name       = var.cluster_name
  })

  depends_on = [
    helm_release.karpenter
  ]
}

resource "kubectl_manifest" "karpenter_node_pool" {
  for_each = fileset("${path.module}/../karpenter-manifests", "**/*.pool.yaml")

  yaml_body = templatefile("${path.module}/../karpenter-manifests/${each.value}", {
    node_iam_role_name = module.karpenter.node_iam_role_name
    cluster_name       = var.cluster_name
  })

  depends_on = [
    helm_release.karpenter
  ]
}
