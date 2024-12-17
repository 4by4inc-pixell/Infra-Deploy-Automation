module "karpenter" {
  source = "terraform-aws-modules/eks/aws//modules/karpenter"
  version = "20.31.1"

  cluster_name                  = var.cluster_name

  enable_v1_permissions         = true

  enable_pod_identity           = true
  create_pod_identity_association = true
  queue_name = var.cluster_queue_name
  node_iam_role_additional_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    AmazonSQSFullAccess = "arn:aws:iam::aws:policy/AmazonSQSFullAccess",
  }

  tags = var.tags

}