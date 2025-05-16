variable "cluster_name" {
  type = string
}
variable "vpc_id" {
  type = string
}
variable "namespace" {
  type    = string
  default = "ray"
}
variable "ray_cluster_name" {
  type = string 
}