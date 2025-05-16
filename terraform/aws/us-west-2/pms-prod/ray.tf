locals {
  ray_cluster_name = "prod-ray-cluster"
  namespace = "ray"
}

module "ray-cluster" {
  depends_on = [ module.eks ]
  source = "../../../modules/ray-cluster"

  ray_cluster_name = local.ray_cluster_name
  namespace = local.namespace
  ray_version = "2.40.0"
  ray_runtime_cpu = "ghcr.io/4by4inc-pixell/pms-ray-cluster:1.0.1-basic"
  ray_runtime_gpu = "ghcr.io/4by4inc-pixell/pms-ray-cluster:1.0.1-trt"
  ray_head_cpu_use = "8"
  ray_head_ram_use = "16Gi"
  ray_cpuworker_cpu_use = "1"
  ray_cpuworker_ram_use = "1Gi"
  ray_cpuworker_replica_min = 0
  ray_cpuworker_replica_max = 0
  ray_gpuworker_cpu_use = "190000m"
  ray_gpuworker_ram_use = "190Gi"
  ray_gpuworker_gpu_use = "8"
  ray_gpuworker_replica_min = 0
  ray_gpuworker_replica_max = 20
}

module "ray-cluster-nlb" {
  depends_on = [ module.eks ]
  source = "../../../modules/ray-cluster-nlb"
 
  cluster_name = var.cluster_name
  vpc_id = module.vpc.vpc_id
  namespace = local.namespace
  ray_cluster_name = local.ray_cluster_name
}