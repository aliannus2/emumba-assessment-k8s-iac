output "namespace" {
  value = kubernetes_namespace.argocd.metadata[0].name
}

output "server_service" {
  value = "${var.release_name}-argocd-server"
}

output "admin_password_cmd" {
  value = "kubectl -n ${kubernetes_namespace.argocd.metadata[0].name} get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d && echo"
}

output "port_forward_cmd" {
  value = "kubectl -n ${kubernetes_namespace.argocd.metadata[0].name} port-forward svc/${var.release_name}-argocd-server 8080:80"
}
