terraform {

  required_version = ">= 1.10.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.30.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.13.0"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.2.4"
    }
  }
}

provider "kubernetes" {
  config_path    = pathexpand("~/.kube/config")
  config_context = var.cluster_name
}

provider "helm" {
  kubernetes = {
    config_path    = pathexpand("~/.kube/config")
    config_context = var.cluster_name
  }
}
