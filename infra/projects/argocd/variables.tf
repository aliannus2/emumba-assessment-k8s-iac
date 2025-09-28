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
variable "cluster_name" {
  type    = string
  default = "emumba-minikube-cluster"
}
