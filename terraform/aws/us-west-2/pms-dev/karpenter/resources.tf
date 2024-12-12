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

# resource "helm_release" "nvidia_device_plugin" {
#   name       = "nvdp"
#   namespace  = "nvidia-device-plugin"
#   repository = "https://nvidia.github.io/k8s-device-plugin"
#   chart      = "nvidia-device-plugin"
#   version    = "0.17.0"

#   create_namespace = true

#   # Helm Chart에 전달할 Values
#   # values = [
#   #   <<-EOF
#   #   plugin:
#   #     logLevel: "info"
#   #   EOF
#   # ]
# }

# resource "helm_release" "nvidia_gpu_operator" {
#   name       = "nvidia-gpu-operator"
#   namespace  = "kube-system"
#   repository = "https://nvidia.github.io/gpu-operator"
#   chart      = "gpu-operator"
#   version    = "24.6.2" # 원하는 버전으로 변경

#   create_namespace = false

#   values = [
#     <<-EOF
#     nvidiaDriver:
#       enabled: true
#     toolkit:
#       enabled: true
#     dcgmExporter:
#       enabled: true
#     nodeFeatureDiscovery:
#       enabled: true
#     gpuFeatureDiscovery:
#       enabled: true
#     EOF
#   ]
# }

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

resource "helm_release" "kubray_operator" {
  name       = "kubray-operator"
  namespace  = "kube-system"
  repository = "https://ray-project.github.io/kuberay-helm/"
  chart      = "kuberay-operator"
  version    = "1.2.2" # 원하는 버전으로 변경

  create_namespace = true
  values = []
}

resource "kubectl_manifest" "ray_cluster" {
  yaml_body = file("${path.module}/../kubectl-manifests/ray-cluster.yaml")

  depends_on = [
    helm_release.kubray_operator
  ]
}

resource "kubectl_manifest" "ray_cluster_nlb" {
  yaml_body = file("${path.module}/../kubectl-manifests/ray-svc-nlb.yaml")

  depends_on = [
    helm_release.kubray_operator
  ]
}

resource "kubectl_manifest" "nvidia_device_plugin" {
  yaml_body = file("${path.module}/../kubectl-manifests/nvidia-device-plugin.yml")
}