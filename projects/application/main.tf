module "application" {
  source = "../../modules/application"

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

  providers = {
    kubernetes = kubernetes
  }
}
