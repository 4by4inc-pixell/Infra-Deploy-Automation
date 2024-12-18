variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}
variable "cluster_endpoint" {
  type        = string
}
variable "cluster_queue_name" {
  type        = string
}
variable "aws_token_username" {
  type        = string
}
variable "aws_token_password" {
  type        = string
}
variable "cluster_certificate_authority_data" {
  type        = string
}
variable "manifests_path" {
  type = string
}


variable "enable_v1_permissions" {
  type = bool
  default = true
}
variable "enable_pod_identity" {
  type = bool
  default = true
}
variable "create_pod_identity_association" {
  type = bool
  default = true
}

variable "tags" {
  description = "Tags to apply to EKS resources"
  type        = map(string)
  default     = {}  # 기본값: 빈 태그
}

