variable "namespace" {
  type    = string
  default = "ray"
}
variable "ray_cluster_name" {
  type = string 
}
variable "ray_version" {
  type = string 
}
variable "ray_autoscaler_idle_timeout_seconds" {
  type = number
  default = 60 
}
variable "ray_autoscaler_cpu_use" {
  type = string
  default = "500m" 
}
variable "ray_autoscaler_ram_use" {
  type = string
  default = "512Mi" 
}
variable "ray_runtime_cpu" {
  type = string
}
variable "ray_runtime_gpu" {
  type = string
}
variable "ray_head_cpu_use" {
  type = string
  default = "4" 
}
variable "ray_head_ram_use" {
  type = string
  default = "8Gi" 
}
variable "ray_cpuworker_cpu_use" {
  type = string
  default = "1" 
}
variable "ray_cpuworker_ram_use" {
  type = string
  default = "4Gi" 
}
variable "ray_cpuworker_replica_min" {
  type = number
  default = 0
}
variable "ray_cpuworker_replica_max" {
  type = number
  default = 10
}
variable "ray_gpuworker_cpu_use" {
  type = string
  default = "4" 
}
variable "ray_gpuworker_ram_use" {
  type = string
  default = "4Gi" 
}
variable "ray_gpuworker_gpu_use" {
  type = string
  default = "1" 
}
variable "ray_gpuworker_replica_min" {
  type = number
  default = 0
}
variable "ray_gpuworker_replica_max" {
  type = number
  default = 10
}
variable "templatefile_path" {
  type = string
  default = "ray-cluster.yaml"
}