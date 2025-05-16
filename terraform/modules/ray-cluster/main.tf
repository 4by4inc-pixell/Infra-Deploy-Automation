resource "kubernetes_manifest" "raycluster" {
  manifest = yamldecode(templatefile("${path.module}/ray-cluster.yaml.tmpl", {
    ray_cluster_name                      = var.ray_cluster_name
    namespace                             = var.namespace
    ray_version                           = var.ray_version
    ray_autoscaler_idle_timeout_seconds   = var.ray_autoscaler_idle_timeout_seconds
    ray_autoscaler_cpu_use                = var.ray_autoscaler_cpu_use
    ray_autoscaler_ram_use                = var.ray_autoscaler_ram_use
    ray_runtime_cpu                       = var.ray_runtime_cpu
    ray_runtime_gpu                       = var.ray_runtime_gpu
    ray_head_cpu_use                      = var.ray_head_cpu_use
    ray_head_ram_use                      = var.ray_head_ram_use
    ray_cpuworker_cpu_use                 = var.ray_cpuworker_cpu_use
    ray_cpuworker_ram_use                 = var.ray_cpuworker_ram_use
    ray_cpuworker_replica_min             = var.ray_cpuworker_replica_min
    ray_cpuworker_replica_max             = var.ray_cpuworker_replica_max
    ray_gpuworker_cpu_use                 = var.ray_gpuworker_cpu_use
    ray_gpuworker_ram_use                 = var.ray_gpuworker_ram_use
    ray_gpuworker_gpu_use                 = var.ray_gpuworker_gpu_use
    ray_gpuworker_replica_min             = var.ray_gpuworker_replica_min
    ray_gpuworker_replica_max             = var.ray_gpuworker_replica_max
  }))
  field_manager {
    name            = "terraform"
    force_conflicts = true
  }
}