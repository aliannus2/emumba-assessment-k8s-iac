variable "cluster_name" {
  description = "Used in labels and for context-aware manifests (passed from project)"
  type        = string
}

variable "argocd_namespace" {
  description = "Namespace where Argo CD is installed"
  type        = string
  default     = "argocd"
}

variable "application_namespace" {
  description = "Namespace where the app will run"
  type        = string
  default     = "emumba-assessment"
}

variable "project_name" {
  description = "Argo CD AppProject name"
  type        = string
  default     = "emumba-deployment"
}

variable "application_name" {
  description = "Argo CD Application name"
  type        = string
  default     = "emumba-assessment-app"
}

variable "github_repo_url" {
  description = "Git repository URL for the app (https)"
  type        = string
}

variable "github_pat" {
  description = "GitHub personal access token (read access)"
  type        = string
  sensitive   = true
}

variable "repo_username" {
  description = "Repository username for basic auth"
  type        = string
  default     = "git"
}

variable "repo_secret_name" {
  description = "K8s Secret name registered in Argo CD"
  type        = string
  default     = "repo-github-emumba-https"
}

variable "kustomize_path" {
  description = "Path inside the repo to Kustomize overlay"
  type        = string
  default     = "k8s/overlays/dev"
}

variable "target_revision" {
  description = "Git revision (branch, tag, or commit SHA)"
  type        = string
  default     = "HEAD"
}

terraform {
  required_providers {
    kubectl = {
      source = "gavinbunney/kubectl"
      version = "1.19.0"
    }
  }
}