variable "cluster_name" {
  description = "Name of the Minikube cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version for Minikube (e.g., v1.30.0 or 'stable')"
  type        = string
}

variable "driver" {
  description = "Minikube driver (docker, hyperv, virtualbox, hyperkit, kvm2, etc.)"
  type        = string
}

variable "nodes" {
  description = "Total nodes (control-plane + workers)"
  type        = number
}

variable "cpus" {
  description = "Number of CPUs allocated to the cluster"
  type        = number
}

variable "memory" {
  description = "RAM for the cluster, e.g. 8192mb, 8g"
  type        = string
}

variable "cni" {
  description = "CNI plugin (auto, bridge, calico, cilium, flannel, kindnet, or path)"
  type        = string
}

variable "addons" {
  description = "Minikube addons to enable"
  type        = set(string)
}

variable "delete_on_failure" {
  description = "Delete cluster if start fails"
  type        = bool
}
