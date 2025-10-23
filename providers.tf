terraform {
  required_version = ">= 1.10.0"
  required_providers {
    minikube = {
      source  = "scott-the-programmer/minikube"
      version = "0.5.5"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.30.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.13.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14.0"
    }
  }
}

provider "minikube" { 
  kubernetes_version = "v1.34.0"
}

provider "kubernetes" {
  host                   = module.minikube.host
  client_certificate     = module.minikube.client_certificate
  client_key             = module.minikube.client_key
  cluster_ca_certificate = module.minikube.cluster_ca_certificate
}

provider "helm" {
  kubernetes = {
    host                   = module.minikube.host
    client_certificate     = module.minikube.client_certificate
    client_key             = module.minikube.client_key
    cluster_ca_certificate = module.minikube.cluster_ca_certificate
  }
}
