variable "minikube_driver" {
  description = "Driver to use for Minikube (docker, hyperv, etc.)"
  type        = string
}

variable "minikube_nodes" {
  description = "Total nodes for Minikube"
  type        = number
}

variable "minikube_cpus" {
  description = "CPUs for Minikube"
  type        = number
}

variable "minikube_memory" {
  description = "Memory for Minikube (e.g., 8192mb, 8g)"
  type        = string
}

variable "minikube_kubernetes_version" {
  description = "Kubernetes version for Minikube"
  type        = string
}

variable "minikube_cni" {
  description = "CNI plugin to use"
  type        = string
}

variable "minikube_addons" {
  description = "Addons to enable"
  type        = set(string)

}

variable "minikube_delete_on_failure" {
  description = "Delete cluster if start fails"
  type        = bool
}

variable "minikube_cluster_name" {
  description = "Name for the Minikube cluster"
  type        = string  
}