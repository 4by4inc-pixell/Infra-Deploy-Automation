variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "pms-prod"
}

variable "region" {
  description = "The AWS region to deploy in"
  default     = "us-west-2"
}

variable "k8s_version" {
  description = "EKS k8s version"
  default     = "1.31"
}

variable "tags" {
  description = "Default tags for all resources"
  type        = map(string)
  default     = {
    cluster-target    = "4by4 pms"
    author = "HyoengSeok Kim"
  }
}