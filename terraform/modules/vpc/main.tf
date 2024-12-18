
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
