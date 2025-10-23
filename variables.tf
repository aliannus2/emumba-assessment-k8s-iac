variable "cluster_name" {
  type    = string
  default = "emumba-minikube-cluster"
}
variable "driver" {
  type    = string
  default = "docker"
}
variable "nodes" {
  type    = number
  default = 2
}
variable "cpus" {
  type    = number
  default = 4
}

variable "memory" {
  type    = number
  default = 8192
}
variable "cni" {
  type    = string
  default = "flannel"
}
variable "namespace" {
  type    = string
  default = "argocd"
}
variable "release_name" {
  type    = string
  default = "argo-cd"
}
variable "server_service_type" {
  type    = string
  default = "NodePort"
}
variable "chart_version" {
  type    = string
  default = "8.5.7"
}
variable "extra_values_yaml" {
  type    = list(string)
  default = []
}

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
