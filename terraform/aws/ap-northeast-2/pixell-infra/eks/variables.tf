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

variable "vpc_id" {
  type        = string
}

variable "private_subnets" {
  type        = list(string)
}

variable "intra_subnets" {
  type        = list(string)
}