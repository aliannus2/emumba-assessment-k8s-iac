output "host" {
  value       = minikube_cluster.this.host
  description = "Kubernetes API server host"
}
output "client_certificate" {
  value       = minikube_cluster.this.client_certificate
  description = "Client certificate (PEM)"
  sensitive   = true
}
output "client_key" {
  value       = minikube_cluster.this.client_key
  description = "Client key (PEM)"
  sensitive   = true
}
output "cluster_ca_certificate" {
  value       = minikube_cluster.this.cluster_ca_certificate
  description = "Cluster CA certificate (PEM)"
}
output "cluster_name" {
  value       = minikube_cluster.this.cluster_name
  description = "Minikube cluster name"
}
