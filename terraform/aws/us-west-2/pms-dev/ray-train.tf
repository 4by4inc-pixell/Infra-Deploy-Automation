locals {
  ray_train_cluster_name = "train-ray-cluster"
  ray_train_namespace = "ray"
}

module "ray-train-cluster" {
  depends_on = [ module.eks ]
  source = "../../../modules/ray-cluster"

  ray_cluster_name = local.ray_train_cluster_name
  namespace = local.ray_train_namespace
  ray_autoscaler_idle_timeout_seconds=180
  ray_version = "2.47.1"
  ray_runtime_cpu = "rayproject/ray:2.47.1-py312-cpu"
  ray_runtime_gpu = "rayproject/ray:2.47.1-py312-gpu"
  ray_head_cpu_use = "7200m"
  ray_head_ram_use = "32Gi"

  ray_cpuworker_cpu_limit = "3600m"
  ray_cpuworker_ram_limit = "8Gi"
  ray_cpuworker_cpu_request = "3000m"
  ray_cpuworker_ram_request = "4Gi"
  ray_cpuworker_replica_min = 0
  ray_cpuworker_replica_max = 64

  ray_gpuworker_cpu_limit = "3600m"
  ray_gpuworker_ram_limit = "16Gi"
  ray_gpuworker_cpu_request = "3000m"
  ray_gpuworker_ram_request = "4Gi"
  ray_gpuworker_gpu_use = "1"
  ray_gpuworker_replica_min = 0
  ray_gpuworker_replica_max = 64
  templatefile_path="ray-cluster-v3.yaml"
}

module "ray-train-cluster-nlb" {
  depends_on = [ module.eks ]
  source = "../../../modules/ray-cluster-nlb"
 
  cluster_name = var.cluster_name
  vpc_id = module.vpc.vpc_id
  namespace = local.ray_train_namespace
  ray_cluster_name = local.ray_train_cluster_name
}