module "minikube" {
  source = "./modules/minikube"

  cluster_name       = var.cluster_name
  kubernetes_version = var.kubernetes_version
  driver             = var.driver
  nodes              = var.nodes
  cpus               = var.cpus
  memory             = var.memory
  cni                = var.cni
  addons             = var.addons
  delete_on_failure  = var.delete_on_failure
}

module "argocd" {
  source              = "./modules/argocd"
  namespace           = "argocd"
  release_name        = "argo-cd"
  server_service_type = "NodePort"
  github_pat          = var.github_pat
  github_repo_url     = var.github_repo_url
  github_username     = var.github_username
  kubeconfig_path     = module.minikube.kubeconfig_path
}