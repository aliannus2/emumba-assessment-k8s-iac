output "cluster_name" {
  value       = module.minikube.cluster_name
  description = "Created Minikube cluster name"
}

output "api_server" {
  value       = module.minikube.host
  description = "Kubernetes API server endpoint"
}

output "how_to_use_kubectl" {
  description = "Tip: set a kubeconfig context to talk to this cluster"
  value       = "kubectl cluster-info && kubectl get nodes"
}
