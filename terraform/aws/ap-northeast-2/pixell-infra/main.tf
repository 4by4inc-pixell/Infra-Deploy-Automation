module "vpc" {
  source = "../../../modules/vpc"
  cluster_name    = var.cluster_name
  number_of_azs = 3
  tags = var.tags
  
}

module "eks" {
  source  = "../../../modules/eks"
  cluster_name    = var.cluster_name
  cluster_version = var.k8s_version
  tags = var.tags
  vpc_id = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  intra_subnets = module.vpc.intra_subnets
  depends_on = [ module.vpc ]
}

module "kubectl" {
  source = "../../../modules/kubectl"
  template_env = {
    "cluster_name": var.cluster_name,
    "node_iam_role_name": module.karpenter.node_iam_role_name,
    "efs_id": resource.aws_efs_file_system.infra.id,
  }
  
  depends_on = [ module.eks ]
  manifests_path = "${path.module}/kubectl-manifests"
}

module "kuberay" {
  source = "../../../modules/kuberay"
  namespace = "ray"
  depends_on = [ module.eks ]
}

module "karpenter" {
  source = "../../../modules/karpenter"
  cluster_name = var.cluster_name
  cluster_endpoint = module.eks.cluster_endpoint
  cluster_queue_name = var.cluster_name
  aws_token_username = data.aws_ecrpublic_authorization_token.token.user_name
  aws_token_password = data.aws_ecrpublic_authorization_token.token.password
  cluster_certificate_authority_data = module.eks.cluster_certificate_authority_data
  manifests_path = "${path.module}/karpenter-manifests"
  tags = var.tags
  depends_on = [ module.eks ]
}