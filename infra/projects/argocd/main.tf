module "argocd" {
  source = "../../modules/argocd"

  namespace           = var.namespace
  release_name        = var.release_name
  server_service_type = var.server_service_type
  chart_version       = var.chart_version
  extra_values_yaml   = var.extra_values_yaml

  providers = {
    kubernetes = kubernetes
    helm       = helm
    null       = null
  }
}
