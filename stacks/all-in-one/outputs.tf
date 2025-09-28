output "argocd_username" {
  value       = "admin"
  description = "Argo CD initial username."
}

output "argocd_admin_password_bash_cmd" {
  value = "kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath=\"{.data.password}\" | base64 -d; echo"
  description = "Run in Bash/zsh/Git Bash to print the Argo CD admin password."
}

output "argocd_admin_password_powershell_cmd" {
  value = "$p=(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath=\"{.data.password}\"); [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($p))"
  description = "Run in Windows PowerShell to print the Argo CD admin password."
}

output "argocd_port_forward_cmd" {
  value       = "kubectl port-forward service/argo-cd-argocd-server -n argocd 8080:443"
  description = "Run this to access Argo CD at https://localhost:8080."
}

output "argocd_url" {
  value       = "https://localhost:8080"
  description = "Open this in your browser after running the port-forward command."
}