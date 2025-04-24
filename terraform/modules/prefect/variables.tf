variable "efs_id" {
  type = string
}
variable "namespace" {
  type    = string
  default = "prefect"
}
variable "certificate_arn" {
  type = string
  
}
variable "domain_url" {
  type = string
  default = "example.com"
}