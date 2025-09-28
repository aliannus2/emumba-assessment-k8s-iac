variable "minikube_driver" {
  description = "Driver to use for Minikube (docker, hyperv, etc.)"
  type        = string
  default     = "docker"
}

variable "minikube_nodes" {
  description = "Total nodes for Minikube"
  type        = number
  default     = 3
}

variable "minikube_cpus" {
  description = "CPUs for Minikube"
  type        = number
  default     = 4
}

variable "minikube_memory" {
  description = "Memory for Minikube (e.g., 8192mb, 8g)"
  type        = string
  default     = "8192mb"
}

variable "minikube_kubernetes_version" {
  description = "Kubernetes version for Minikube"
  type        = string
  default     = "v1.30.0"
}

variable "minikube_cni" {
  description = "CNI plugin to use"
  type        = string
  default     = "bridge"
}

variable "minikube_addons" {
  description = "Addons to enable"
  type        = set(string)
  default = [
    "dashboard",
    "default-storageclass",
    "ingress",
    "metrics-server",
    "storage-provisioner",
  ]
}

variable "minikube_delete_on_failure" {
  description = "Delete cluster if start fails"
  type        = bool
  default     = true
}

