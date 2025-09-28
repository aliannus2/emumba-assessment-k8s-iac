terraform {
  required_version = ">= 1.6.0"
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.38.0"
    }
  }
}

variable "cluster_name" {
  description = "Minikube cluster name (used as kube context)"
  type        = string
  default     = "emumba-minikube-cluster"
}

provider "kubernetes" {
  config_path    = pathexpand("~/.kube/config")
  config_context = var.cluster_name
}
