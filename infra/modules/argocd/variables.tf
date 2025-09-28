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
