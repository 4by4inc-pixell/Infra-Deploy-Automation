

resource "aws_iam_role" "aws_load_balancer_controller_role" {
  name               = "aws-load-balancer-controller-role"
  assume_role_policy = data.aws_iam_policy_document.lb_controller_assume_role_policy.json
}

resource "kubernetes_service_account" "aws_load_balancer_controller_sa" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.aws_load_balancer_controller_role.arn
    }
  }

  depends_on = [
    module.eks,                         # EKS 클러스터가 생성된 후
    aws_iam_role.aws_load_balancer_controller_role # IAM Role이 준비된 후
  ]
}

# resource "aws_iam_role_policy_attachment" "aws_lb_controller_policy_attach" {
  
#   for_each = toset([
#     "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
#     "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
#   ])

#   policy_arn = each.value
#   role       = aws_iam_role.aws_load_balancer_controller_role.name
# }

resource "aws_iam_role_policy_attachment" "aws_lb_controller_policy_attach" {
  policy_arn = aws_iam_policy.aws_lb_controller_policy.arn
  role       = aws_iam_role.aws_load_balancer_controller_role.name
}

resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  namespace  = "kube-system"
  chart      = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  version    = "1.7.1" # Replace with the desired version
  values = [
    <<EOF
clusterName: ${var.cluster_name}
serviceAccount:
  create: false
  name: aws-load-balancer-controller
EOF
  ]
  depends_on = [kubernetes_service_account.aws_load_balancer_controller_sa]
}


resource "kubectl_manifest" "user_k8s_manifests" {
  for_each = fileset("${path.module}/kubectl-manifests", "**/*.yaml")
  yaml_body = templatefile("${path.module}/kubectl-manifests/${each.value}", {
    node_iam_role_name = module.karpenter.node_iam_role_name
    cluster_name       = var.cluster_name
  })
  depends_on = [
    module.karpenter
  ]
}

resource "kubectl_manifest" "secrets" {
  for_each = fileset("${path.module}/kubectl-secrets", "**/*.yaml")
  yaml_body = templatefile("${path.module}/kubectl-secrets/${each.value}", {
  })
  depends_on = [
    module.karpenter
  ]
  
}