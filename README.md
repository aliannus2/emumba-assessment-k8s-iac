# Local GitOps on Minikube (Terraform + Argo CD)

Spin up a local Kubernetes cluster with **Minikube**, install **Argo CD** via Helm, and deploy your app GitOps-style — all with Terraform.

Each component is a **standalone Terraform project** (cluster / argocd / application), and there's an optional **all-in-one stack** that orchestrates all projects for a one-shot deployment.

## Table of Contents

- [Repository Layout](#repository-layout)
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
- [Individual Project Deployment](#individual-project-deployment)
- [Manifest Structure](#manifest-structure)
- [Configuration](#configuration)
- [Accessing Argo CD](#accessing-argo-cd)
- [Cleanup](#cleanup)
- [Troubleshooting](#troubleshooting)
- [Notes](#notes)

## Repository Layout

```
modules/
├── cluster-minikube/    # Minikube cluster management (reusable)
├── argocd/              # Argo CD Helm installation (reusable)
└── application/         # Argo CD Project + Application (reusable)

projects/
├── cluster/             # Standalone TF: creates Minikube cluster
├── argocd/              # Standalone TF: installs Argo CD
└── application/         # Standalone TF: registers repo + Argo App

stacks/
└── all-in-one/          # Optional: orchestrates all 3 projects
```

> Each **project** has its own `providers.tf`, `variables.tf`, and `terraform.tfvars`.  
> Providers read `~/.kube/config`. Application project sets `config_context = var.cluster_name`.

## Prerequisites

- **Terraform** ≥ 1.10.0
- **Minikube** + **Docker** (or another supported driver)
- **kubectl**, **Helm**, and **Kustomize**
- A Git repository with your Kustomize layout (see [Manifest Structure](#manifest-structure))
- A GitHub **Personal Access Token (PAT)** with read access to that repository

> On Windows, use **PowerShell** or **Git Bash**. All commands below are provided as single lines.

## Getting Started

### 1. Configure Your Application Settings

Before deploying, you need to configure your GitHub repository and credentials:

1. **Navigate to the application project:**
   ```bash
   cd projects/application/
   ```

2. **Copy the example configuration:**
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

3. **Edit `terraform.tfvars` and update:**
   - `github_repo_url`: Replace with your actual GitHub repository URL
   - `github_pat`: Add your GitHub Personal Access Token (PAT) with read access to the repository

   **⚠️ Security Note:** Instead of putting your PAT directly in the file, you can set it as an environment variable:
   ```bash
   export TF_VAR_github_pat="ghp_XXXXXXXXXXXXXXXX"
   ```
   Then leave `github_pat = ""` in the terraform.tfvars file.

4. **Return to the repository root:**
   ```bash
   cd ../../
   ```

### 2. All-in-One Deployment

The fastest way to get everything running! This stack orchestrates all three projects in the correct order.

Run from `stacks/all-in-one/`:

```bash
terraform init && terraform apply -auto-approve
```

The stack provides helpful outputs including Argo CD access instructions once deployment completes.

## Individual Project Deployment

If you prefer granular control, deploy each component individually. Run from the repository root - each project reads its **own** `terraform.tfvars`.

### 1. Create Minikube Cluster
```bash
terraform -chdir=projects/cluster init -upgrade && terraform -chdir=projects/cluster apply -auto-approve
```

### 2. Install Argo CD
```bash
terraform -chdir=projects/argocd init -upgrade && terraform -chdir=projects/argocd apply -auto-approve
```

### 3. Deploy Application
```bash
terraform -chdir=projects/application init -upgrade && terraform -chdir=projects/application apply -auto-approve
```

## Manifest Structure

Your Git repository should contain Kubernetes manifests organized with Kustomize. Here's the expected structure:

```
k8s/
├── base/
│   ├── namespace.yaml
│   ├── resourcequota.yaml
│   ├── rbac/
│   │   ├── role-readonly.yaml
│   │   ├── role-readwrite.yaml
│   │   ├── rolebinding-readonly.yaml
│   │   └── rolebinding-readwrite.yaml
│   ├── apigateway/
│   │   ├── deployment.yaml
│   │   ├── service.yaml
│   │   └── configmap.yaml
│   ├── quoteservice/
│   │   ├── deployment.yaml
│   │   ├── service.yaml
│   │   └── configmap.yaml
│   ├── frontend/
│   │   ├── deployment.yaml
│   │   ├── service.yaml
│   │   └── configmap.yaml
│   └── kustomization.yaml
└── overlays/
    └── dev/
        └── kustomization.yaml
```

The `kustomize_path` in your configuration should point to the overlay you want to deploy (e.g., `k8s/overlays/dev`).

Configure each project by editing its respective `terraform.tfvars` file:

### projects/cluster/terraform.tfvars
```hcl
cluster_name        = "emumba-minikube-cluster"
driver              = "docker"
nodes               = 1
cpus                = 4
memory              = 8192
kubernetes_version  = "v1.34.0"
cni                 = "flannel"
extra_flags         = ["--addons=ingress,metrics-server", "--preload=false"]
```

### projects/argocd/terraform.tfvars
```hcl
namespace           = "argocd"
release_name        = "argo-cd"
server_service_type = "NodePort"
chart_version       = "8.5.7"
```

### projects/application/terraform.tfvars
```hcl
cluster_name          = "emumba-minikube-cluster"
argocd_namespace      = "argocd"
application_namespace = "emumba-assessment"

project_name          = "emumba-deployment"
application_name      = "emumba-assessment-app"

github_repo_url = "https://github.com/your-org/your-repo.git"
github_pat      = ""
kustomize_path  = "k8s/overlays/dev"
target_revision = "HEAD"
```

## All-in-One Stack

This stack orchestrates all three projects in the correct order (init → apply).

Run from `stacks/all-in-one/`:

```bash
terraform init && terraform apply -auto-approve
```

The stack provides helpful outputs including Argo CD access instructions.

## Accessing Argo CD

### Get Admin Password

**Bash/Git Bash:**
```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
```

**PowerShell:**
```powershell
$p=(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}"); [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($p))
```

### Access the UI

1. **Port-forward to Argo CD:**
   ```bash
   kubectl port-forward service/argo-cd-argocd-server -n argocd 8080:443
   ```

2. **Open:** https://localhost:8080

3. **Login:** 
   - Username: `admin`
   - Password: (from commands above)

## Cleanup

Destroy resources in reverse order:

### Individual Projects
```bash
terraform -chdir=projects/application destroy -auto-approve
terraform -chdir=projects/argocd destroy -auto-approve
terraform -chdir=projects/cluster destroy -auto-approve
```

### All-in-One Stack
From `stacks/all-in-one/`:
```bash
terraform destroy -auto-approve
```

## Troubleshooting

### Context not found / Connection refused
- Ensure Minikube is running and `cluster_name` matches your Minikube profile
- Check: `kubectl config get-contexts` and `minikube profile list`

### Argo CD CRDs missing
- Apply `projects/argocd` before `projects/application`

### Port 8080 already in use
- Change the local port: `kubectl port-forward ... 9090:443`

### Windows CRLF issues in shell scripts
- Use PowerShell for one-liners, or set `*.tf text eol=lf` in `.gitattributes`

### Re-run a single stage
- Just rerun its one-liner (e.g., `terraform -chdir=projects/argocd apply -auto-approve`)

## Notes

- **Argo CD Helm values include:**
  - `installCRDs = true`
  - `server.insecure = true` 
  - Service type configurable via `server_service_type`

- **Application project uses `kubernetes_manifest` to create:**
  - Argo CD AppProject
  - Argo CD Application (pointing at `github_repo_url` + `kustomize_path`)

- **Security:** Always prefer `TF_VAR_github_pat` environment variable over committing tokens to files or shell history
