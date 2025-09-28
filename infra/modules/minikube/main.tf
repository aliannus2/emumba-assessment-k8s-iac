terraform {
  required_version = ">= 1.10.0"
  required_providers {
    minikube = {
      source  = "scott-the-programmer/minikube"
      version = ">= 0.5.3"
    }
  }
}

provider "minikube" {
  kubernetes_version = var.kubernetes_version
}

resource "minikube_cluster" "this" {
  cluster_name      = var.cluster_name
  driver            = var.driver
  nodes             = var.nodes
  cpus              = var.cpus
  memory            = var.memory
  cni               = var.cni
  delete_on_failure = var.delete_on_failure
  addons            = var.addons
}
