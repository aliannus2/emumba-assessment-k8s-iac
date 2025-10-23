# Local GitOps with Terraform + Argo CD

Automated local Kubernetes environment with GitOps deployment using Terraform, Minikube, and Argo CD.

## Prerequisites

Install the following tools:

- **Docker Desktop** - [Download here](https://www.docker.com/products/docker-desktop)
- **Minikube** - `choco install minikube -y` (Windows) or `brew install minikube` (Mac)
- **kubectl** - `choco install kubernetes-cli -y` or `brew install kubectl`
- **Helm** - `choco install kubernetes-helm -y` or `brew install kubernetes-helm`
- **Terraform** - `choco install terraform -y` or `brew install hashicorp/tap/terraform`

## Project Structure

The application manifests are organized using Kustomize:

```
k8s/
├── base/                      # Base Kubernetes resources
│   ├── apigateway/           # API Gateway service
│   ├── frontend/             # Frontend service
│   ├── quoteservice/         # Quote service
│   └── rbac/                 # RBAC policies
└── overlays/
    └── dev/                  # Development environment overlay
```

Argo CD deploys from `k8s/overlays/dev` using Kustomize, which applies environment-specific patches on top of the base manifests.

## Quick Start

1. **Start Docker Desktop** and ensure it's running

2. **Configure your deployment** by editing `terraform.tfvars`:
   ```hcl
   cluster_name    = "emumba-minikube-cluster"
   github_repo_url = "https://github.com/aliannus2/emumba-assessment-k8s-iac"
   github_pat      = ""  # Or set via: $Env:TF_VAR_github_pat = "ghp_..."
   kustomize_path  = "k8s/overlays/dev"
   ```

3. **Deploy everything**:
   ```bash
   terraform init
   terraform apply -auto-approve
   ```

This provisions:
- Local Minikube cluster
- Argo CD (via Helm)
- Your application (from Git repo)

## Access Argo CD

**Get the URL:**
```bash
kubectl port-forward -n argocd svc/argo-cd-argocd-server 8080:80
```

Now Argocd console should be accessible on http://localhost:8080/

**Get admin password:**
```powershell
$p=(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}"); [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($p))
```

**Login:** Username `admin` with the password from above

## Verify Deployment

```bash
kubectl get nodes
kubectl get pods -A
kubectl get pods -n emumba-app
```

## Cleanup

```bash
terraform destroy -auto-approve
```

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Connection refused | Run `minikube start` |
| App not syncing | Wait 30s for Argo CD to initialize |
| Port already in use | Change port: `kubectl port-forward -n argocd svc/argo-cd-argocd-server 9090:80` |

---

**Architecture:** Terraform → Minikube Cluster → Argo CD → GitOps Application Deployment