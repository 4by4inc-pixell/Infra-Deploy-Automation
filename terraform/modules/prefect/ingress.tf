resource "kubernetes_ingress_v1" "prefect" {
  metadata {
    name      = "prefect-ingress"
    namespace = kubernetes_namespace.prefect.metadata[0].name

    annotations = {
      "alb.ingress.kubernetes.io/scheme"          = "internet-facing"
      "alb.ingress.kubernetes.io/target-type"     = "ip"
      "alb.ingress.kubernetes.io/listen-ports"    = "[{\"HTTP\": 80}, {\"HTTPS\": 443}]"
      "alb.ingress.kubernetes.io/certificate-arn" = var.certificate_arn
      "alb.ingress.kubernetes.io/actions.ssl-redirect" = jsonencode({
        Type           = "redirect",
        RedirectConfig = {
          Protocol   = "HTTPS",
          Port       = "443",
          StatusCode = "HTTP_301"
        }
      })
    }
  }

  spec {
    ingress_class_name = "alb"
    rule {
      host = var.domain_url
      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "ssl-redirect"
              port {
                name = "use-annotation"
              }
            }
          }
        }
      }
    }

    rule {
      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = helm_release.prefect.metadata[0].name
              port {
                number = 4200
              }
            }
          }
        }
      }
    }
  }
}