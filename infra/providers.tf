terraform {
  required_version = ">= 1.10.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.38.0"
    }
    minikube = {
      source  = "scott-the-programmer/minikube"
      version = ">= 0.5.3"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "3.0.2"
    }
  }
}

# provider "kubernetes" {
#   host                   = module.minikube.host
#   client_certificate     = module.minikube.client_certificate
#   client_key             = module.minikube.client_key
#   cluster_ca_certificate = module.minikube.cluster_ca_certificate
# }

# provider "helm" {
#   kubernetes = {
#     host                   = module.minikube.host
#     client_certificate     = module.minikube.client_certificate
#     client_key             = module.minikube.client_key
#     cluster_ca_certificate = module.minikube.cluster_ca_certificate
#   }

#   # keep repo cache local to the repo (prevents Temp-path issues on Windows)
#   repository_config_path = "${path.module}/.helm/repositories.yaml"
#   repository_cache       = "${path.module}/.helm/cache"
# }