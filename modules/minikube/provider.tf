terraform {
  required_version = ">= 1.10.0"
  required_providers {
    minikube = {
      source  = "scott-the-programmer/minikube"
      version = "0.5.5"
    }
  }
}
