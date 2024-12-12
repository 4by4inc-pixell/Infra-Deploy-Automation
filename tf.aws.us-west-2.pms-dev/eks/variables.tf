variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "Version of the EKS cluster"
  type        = string
  default     = "1.31"  # 기본값 설정 가능
}

variable "tags" {
  description = "Tags to apply to EKS resources"
  type        = map(string)
  default     = {}  # 기본값: 빈 태그
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "number_of_azs" {
  description = "Number of availability zones"
  type        = number
  default     = 3
}

variable "enable_nat_gateway" {
  description = "Enable NAT gateway"
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Enable single NAT gateway"
  type        = bool
  default     = true
}

variable "public_subnet_tags" {
  description = "Tags for private subnets"
  type        = map(string)
  default     = {
    "kubernetes.io/role/elb" = 1
  }
}

variable "private_subnet_tags" {
  description = "Tags for private subnets"
  type        = map(string)
  default     = {
    "kubernetes.io/role/internal-elb" = 1
  }
}