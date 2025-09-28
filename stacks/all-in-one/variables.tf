# Minimal inputs — keep everything else defaulted in each project.

variable "cluster_name" {
  description = "Minikube profile / kube context used by Application project"
  type        = string
  default     = "emumba-minikube-cluster"
}

variable "github_repo_url" {
  description = "HTTPS repo URL that Argo CD Application will sync"
  type        = string
}

variable "github_pat" {
  description = "GitHub token with read access"
  type        = string
  sensitive   = true
}
