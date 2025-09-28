terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "3.2.4"
    }
  }
}

locals {
  start_cmd = join(" ", [
    "minikube start",
    "--profile=${var.cluster_name}",
    "--driver=${var.driver}",
    "--nodes=${var.nodes}",
    "--cpus=${var.cpus}",
    "--memory=${var.memory}",
    "--kubernetes-version=${var.kubernetes_version}",
    "--cni=${var.cni}"
  ])
}

resource "null_resource" "minikube_cluster" {
  triggers = {
    cmd          = local.start_cmd
    profile_name = var.cluster_name
  }

  provisioner "local-exec" {
    command = local.start_cmd
  }

  provisioner "local-exec" {
    when = destroy
    command = "minikube delete -p ${self.triggers.profile_name}"
  }
}
