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
  default = 2
}

variable "memory" {
  type    = number
  default = 8192
  
}
