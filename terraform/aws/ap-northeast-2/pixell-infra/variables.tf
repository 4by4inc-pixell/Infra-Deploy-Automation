variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "pixell-infra"
}

variable "region" {
  description = "The AWS region to deploy in"
  default     = "ap-northeast-2"
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

variable "env_path" {
  description = "env file path"
  type        = string
  default     = "./.env"
}

variable "certificate_arn" {
  description = "value of certificate_arn"
  type        = string
  default     = "arn:aws:acm:ap-northeast-2:760235743813:certificate/18d5258b-464a-4b9f-a34e-ddbb47bc9888"
}