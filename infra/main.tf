module "minikube" {
  source = "./modules/minikube"

  cluster_name       = "emumba-minikube-cluster"
  kubernetes_version = var.minikube_kubernetes_version
  driver             = var.minikube_driver
  nodes              = var.minikube_nodes
  cpus               = var.minikube_cpus
  memory             = var.minikube_memory
  cni                = var.minikube_cni
  addons             = var.minikube_addons
  delete_on_failure  = var.minikube_delete_on_failure
}

# module "argocd" {
#   depends_on = [module.minikube]
#   source     = "./modules/argocd"

#   namespace           = "argocd"
#   release_name        = "argo-cd"
#   server_service_type = "NodePort"
# }
