terraform {
  required_version = ">= 1.10.0"
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = ">= 3.2.0"
    }
  }
}

resource "null_resource" "minikube" {
  triggers = {
    profile = var.cluster_name
  }

  provisioner "local-exec" {
    command = "minikube start --profile=${self.triggers.profile} --driver=${var.driver} --nodes=${var.nodes} --cpus=${var.cpus} --memory=${var.memory} --kubernetes-version=${var.kubernetes_version} --cni=${var.cni}"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "minikube delete -p ${self.triggers.profile}"
  }
}
