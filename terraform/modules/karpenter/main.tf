module "karpenter" {
  source = "terraform-aws-modules/eks/aws//modules/karpenter"
  version = "20.31.1"

  cluster_name                  = var.cluster_name

  enable_v1_permissions         = var.enable_v1_permissions

  enable_pod_identity           = var.enable_pod_identity
  create_pod_identity_association = var.create_pod_identity_association
  queue_name = var.cluster_queue_name
  node_iam_role_additional_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  tags = var.tags

}