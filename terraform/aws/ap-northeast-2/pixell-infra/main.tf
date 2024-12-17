
module "vpc" {
  source  = "./vpc"
  cluster_name    = var.cluster_name
  number_of_azs = 3
  tags = var.tags
}

module "eks" {
  source  = "./eks"
  cluster_name    = var.cluster_name
  cluster_version = var.k8s_version
  tags = var.tags
  vpc_id=module.vpc.vpc_id
  private_subnets=module.vpc.private_subnets
  intra_subnets=module.vpc.intra_subnets
  depends_on = [ module.vpc ]
}

module "karpenter" {
  source = "./karpenter"
  cluster_name = var.cluster_name
  cluster_endpoint = module.eks.cluster_endpoint
  cluster_queue_name = var.cluster_name
  aws_token_username = data.aws_ecrpublic_authorization_token.token.user_name
  aws_token_password = data.aws_ecrpublic_authorization_token.token.password
  cluster_certificate_authority_data = module.eks.cluster_certificate_authority_data
  tags = var.tags
  depends_on = [ module.eks ]
}
