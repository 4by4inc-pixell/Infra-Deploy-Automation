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


variable "tags" {
  description = "Tags to apply to EKS resources"
  type        = map(string)
  default     = {}  # 기본값: 빈 태그
}

