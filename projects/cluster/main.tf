module "cluster_minikube" {
  source = "../../modules/cluster-minikube"

  cluster_name       = var.cluster_name
  driver             = var.driver
  nodes              = var.nodes
  cpus               = var.cpus
  memory             = var.memory
  kubernetes_version = var.kubernetes_version
  cni                = var.cni
}
