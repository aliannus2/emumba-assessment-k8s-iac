resource "kubernetes_namespace" "argocd" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/name"       = "argocd"
      "app.kubernetes.io/part-of"    = "emumba-minikube-cluster"
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }
}

locals {
  base_values = yamlencode({
    installCRDs = true
    configs = {
      params = {
        "server.insecure" = "true"
      }
    }
    server = {
      service = {
        type = var.server_service_type
      }
    }
  })
  merged_values = concat([local.base_values], var.extra_values_yaml)
}

resource "helm_release" "argocd" {
  name       = var.release_name
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = kubernetes_namespace.argocd.metadata[0].name
  version    = var.chart_version

  wait    = true
  timeout = 600

  values = local.merged_values
}

