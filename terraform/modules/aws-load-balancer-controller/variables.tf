variable "region" {
  type = string 
}
variable "cluster_name" {
  type = string
}
variable "vpc_id" {
  type = string
}
variable "cluster_oidc_issuer_url" {
  type = string
}
variable "k8s_service_account_name" {
  type = string
  default = "aws-load-balancer-controller"
}
variable "namespace" {
  type    = string
  default = "kube-system"
}