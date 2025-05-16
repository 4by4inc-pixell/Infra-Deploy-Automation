resource "kubernetes_service" "raycluster_head_nlb" {
  metadata {
    name      = "${var.ray_cluster_name}-nlb"
    namespace = "${var.namespace}"
    labels = {
      app = "${var.ray_cluster_name}"
    }

    annotations = {
      "service.beta.kubernetes.io/aws-load-balancer-name"                            = "${var.ray_cluster_name}-nlb"
      "service.beta.kubernetes.io/aws-load-balancer-additional-resource-tags"        = "generator=terraform"
      "service.beta.kubernetes.io/aws-load-balancer-security-groups"                 = "${aws_security_group.ray_cluster_sg.id}"
      "service.beta.kubernetes.io/aws-load-balancer-manage-backend-security-group-rules" = "true"
      "service.beta.kubernetes.io/aws-load-balancer-type"                            = "nlb"
      "service.beta.kubernetes.io/aws-load-balancer-scheme"                          = "internet-facing"
      "service.beta.kubernetes.io/aws-load-balancer-nlb-target-type"                = "instance"
      "service.beta.kubernetes.io/aws-load-balancer-healthcheck-protocol"           = "TCP"
      "service.beta.kubernetes.io/aws-load-balancer-healthcheck-port"               = "traffic-port"
      "service.beta.kubernetes.io/aws-load-balancer-healthcheck-interval"           = "20"
      "service.beta.kubernetes.io/aws-load-balancer-healthcheck-timeout"            = "5"
      "service.beta.kubernetes.io/aws-load-balancer-healthcheck-threshold-count"    = "3"
      "service.beta.kubernetes.io/aws-load-balancer-healthcheck-unhealthy-threshold-count" = "3"
    }
  }

  spec {
    selector = {
      "app.kubernetes.io/created-by" = "kuberay-operator"
      "app.kubernetes.io/name"       = "kuberay"
      "ray.io/cluster"               = "${var.ray_cluster_name}"
      "ray.io/identifier"            = "${var.ray_cluster_name}-head"
      "ray.io/node-type"             = "head"
    }

    type                   = "LoadBalancer"
    external_traffic_policy = "Local"

    port {
      name        = "dashboard"
      port        = 80
      target_port = 8265
      protocol    = "TCP"
    }

    port {
      name        = "metrics"
      port        = 8080
      target_port = 8080
      protocol    = "TCP"
    }

    port {
      name        = "client"
      port        = 10001
      target_port = 10001
      protocol    = "TCP"
    }
  }
}