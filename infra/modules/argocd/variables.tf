variable "namespace" {
  description = "Namespace for Argo CD"
  type        = string
  default     = "argocd"
}

variable "release_name" {
  description = "Helm release name"
  type        = string
  default     = "argo-cd"
}

variable "server_service_type" {
  description = "Service type for Argo CD server"
  type        = string
  default     = "NodePort"
}

variable "application_name" {
  description = "Name of the Argo CD Application"
  type        = string
  default     = "emumba-assessment-app"
}

variable "github_repo_url" {
  type        = string
  description = "HTTPS URL to the repo"
  default     = "https://github.com/aliannus2/emumba-assessment-k8s-iac.git"
}
variable "github_pat" {
  type        = string
  description = "GitHub Personal Access Token (read-only)"
  sensitive   = true
}

variable "github_username" {
  type        = string
  description = "GitHub username or organization name"
  default     = "aliannus2"
}

variable "kubeconfig_path" {
  type        = string
  description = "Path to kubeconfig file"
}