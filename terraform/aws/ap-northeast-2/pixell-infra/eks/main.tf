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

  vpc_id                   = var.vpc_id
  subnet_ids               = var.private_subnets
  control_plane_subnet_ids = var.intra_subnets

  eks_managed_node_groups = {
    karpenter = {
      ami_type       = "AL2_x86_64"
      instance_types = ["m5.large"]
      min_size       = 1
      max_size       = 4
      desired_size   = 2

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

