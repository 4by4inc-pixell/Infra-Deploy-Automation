module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.31.1"

  cluster_name          = var.cluster_name
  cluster_version       = var.cluster_version
  
  enable_cluster_creator_admin_permissions = true
  cluster_endpoint_public_access           = true

  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.intra_subnets

  eks_managed_node_groups = {
    karpenter = {
      ami_type       = "AL2_x86_64"
      instance_types = ["m5.large"]
      min_size       = 1
      max_size       = 4
      desired_size   = 1

      iam_role_additional_policies = {
        "AmazonEKSWorkerNodePolicy"          = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
        "AmazonEC2ContainerRegistryReadOnly" = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
        "AmazonEKS_CNI_Policy"              = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
        "AmazonSSMManagedInstanceCore"              = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
      }
    }
  }

  node_security_group_tags = merge(var.tags, {
    "karpenter.sh/discovery" = var.cluster_name
  })

  tags = var.tags
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name            = var.cluster_name
  cidr            = var.vpc_cidr
  azs             = slice(data.aws_availability_zones.available.names, 0, var.number_of_azs)
  private_subnets = [for k, v in slice(data.aws_availability_zones.available.names, 0, var.number_of_azs) : cidrsubnet(var.vpc_cidr, 4, k)]
  public_subnets  = [for k, v in slice(data.aws_availability_zones.available.names, 0, var.number_of_azs) : cidrsubnet(var.vpc_cidr, 8, k + 48)]
  intra_subnets   = [for k, v in slice(data.aws_availability_zones.available.names, 0, var.number_of_azs) : cidrsubnet(var.vpc_cidr, 8, k + 52)]

  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway

  public_subnet_tags = merge(var.public_subnet_tags, {
    "karpenter.sh/discovery" = var.cluster_name
  })
  

  private_subnet_tags = merge(var.private_subnet_tags, {
    "karpenter.sh/discovery" = var.cluster_name
  })
  

  tags = var.tags
}
