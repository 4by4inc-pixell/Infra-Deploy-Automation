terraform {
  required_version = ">= 1.3.2"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.35.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.79"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.7"
    }
    kubectl = {
      source  = "alekc/kubectl"
      version = "~> 2.1.3"
    }
  }
}
