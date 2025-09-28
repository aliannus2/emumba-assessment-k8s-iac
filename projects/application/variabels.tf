# You already defined cluster_name in providers.tf

variable "argocd_namespace" {
  type    = string
  default = "argocd"
}
variable "application_namespace" {
  type    = string
  default = "emumba-assessment"
}
variable "project_name" {
  type    = string
  default = "emumba-deployment"
}
variable "application_name" {
  type    = string
  default = "emumba-assessment-app"
}

variable "github_repo_url" {
  type        = string
  description = "HTTPS repo URL that Argo CD will pull from"
}

variable "github_pat" {
  type        = string
  sensitive   = true
  description = "GitHub token with read access"
}

variable "repo_username" {
  type    = string
  default = "aliannus2"
}
variable "repo_secret_name" {
  type    = string
  default = "repo-github-emumba-https"
}
variable "kustomize_path" {
  type    = string
  default = "k8s/overlays/dev"
}
variable "target_revision" {
  type    = string
  default = "HEAD"
}
