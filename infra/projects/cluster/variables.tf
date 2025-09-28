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
  default = 1
}
variable "cpus" {
  type    = number
  default = 4
}
variable "memory" {
  type    = number
  default = 8192
}
variable "kubernetes_version" {
  type    = string
  default = "v1.34.0"
}
variable "cni" {
  type    = string
  default = "flannel"
}
