terraform {
  required_version = ">= 1.10.0"
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "3.2.4"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.38.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "3.0.2"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes = {
    config_path    = "~/.kube/config"
    config_context = "emumba-minikube-cluster"
  }
}
