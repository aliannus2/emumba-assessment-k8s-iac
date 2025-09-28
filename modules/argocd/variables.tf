variable "namespace" {
  description = "Namespace for Argo CD control plane"
  type        = string
  default     = "argocd"
}

variable "release_name" {
  description = "Helm release name"
  type        = string
  default     = "argo-cd"
}

variable "server_service_type" {
  description = "Service type for argocd-server (ClusterIP|NodePort|LoadBalancer)"
  type        = string
  default     = "ClusterIP"
}

variable "chart_version" {
  description = "argo-helm chart version"
  type        = string
  default     = "8.5.7"
}

variable "extra_values_yaml" {
  description = "Optional extra Helm values as YAML strings (each item is a full YAML document)"
  type        = list(string)
  default     = []
}

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
