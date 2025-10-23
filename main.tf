module "minikube" {
  source = "./modules/minikube"

  cluster_name = var.cluster_name
  driver       = var.driver
  nodes        = var.nodes
  cpus         = var.cpus
}


module "argocd" {
  source = "./modules/argocd"

  namespace           = var.namespace
  release_name        = var.release_name
  server_service_type = var.server_service_type
  chart_version       = var.chart_version
  extra_values_yaml   = var.extra_values_yaml

  providers = {
    kubernetes = kubernetes
    helm       = helm
  }

  depends_on = [module.minikube]
}

resource "time_sleep" "wait_for_argocd" {
  depends_on = [module.argocd]
  create_duration = "45s"
}

module "application" {
  source = "./modules/application"
  providers = {
    kubectl = kubectl
  }

  cluster_name          = var.cluster_name
  argocd_namespace      = var.argocd_namespace
  application_namespace = var.application_namespace

  project_name     = var.project_name
  application_name = var.application_name

  github_repo_url  = var.github_repo_url
  github_pat       = var.github_pat
  repo_username    = var.repo_username
  repo_secret_name = var.repo_secret_name

  kustomize_path  = var.kustomize_path
  target_revision = var.target_revision

  depends_on = [time_sleep.wait_for_argocd]
}
