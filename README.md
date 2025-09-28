# GitOps Kubernetes Setup

A simple GitOps-style local Kubernetes setup using **Terraform**, **Minikube**, **Argo CD**, and **Kustomize**.

## Prerequisites

Install the following tools for your operating system:
- Docker
- Terraform (>= 1.10)
- Minikube
- kubectl
- Helm
- Kustomize

## Getting Started

### 1. Clone and Setup

```bash
git clone <repository-url>
cd emumba-assessment-k8s-iac
```

### 2. Configure Terraform Variables

Create `infra/terraform.tfvars` with your local settings and GitHub token (**do not** commit this file):

```hcl
# --- Cluster Configuration ---
cluster_name        = "emumba-minikube-cluster"
kubernetes_version  = "v1.30.0"
driver              = "docker"
nodes               = 3
cpus                = 4
memory              = "8192mb"
cni                 = "bridge"
delete_on_failure   = true

# --- Argo CD Configuration ---
namespace           = "argocd"
release_name        = "argo-cd"
server_service_type = "NodePort"

# --- Repository Configuration ---
github_repo_url     = "https://github.com/<your-username>/emumba-assessment-k8s-iac.git"
github_pat          = "ghp_********"
```

### 3. Deploy the Stack

From the `infra` directory, run Terraform to:
- Start Minikube cluster
- Install Argo CD
- Bootstrap GitOps

```bash
cd infra
terraform init
terraform apply -auto-approve
```

### 4. Verify Deployment

Check if everything is running correctly:

```bash
# Check Argo CD applications
kubectl -n argocd get appprojects,applications

# Check application deployments
kubectl -n emumba-assessment get deploy,svc
```

## GitOps Configuration

This repository follows GitOps principles:

- **Manifest Location**: All Kubernetes manifests are stored under `k8s/`
- **Sync Path**: Argo CD syncs from `k8s/overlays/dev`
- **Automated Deployment**: No manual `kubectl apply` required
- **Change Tracking**: Argo CD automatically tracks and syncs repository changes

### Repository Configuration

If you fork this repository to a different location, update the `github_repo_url` in `infra/terraform.tfvars` before applying Terraform.

### Environment Variables (Optional)

For scripting purposes, you can set your GitHub PAT as an environment variable:

**Windows:**
```cmd
set GITHUB_PAT=ghp_********
```

**Linux/macOS:**
```bash
export GITHUB_PAT=ghp_********
```

> **Note:** Your PAT is only used by Terraform providers. Never commit it to the repository.

## Directory Structure

```
emumba-assessment-k8s-iac/
├── README.md
├── infra/                          # Terraform infrastructure code
│   ├── providers.tf
│   ├── variables.tf
│   ├── main.tf
│   ├── outputs.tf
│   └── terraform.tfvars            # Local config (not committed)
├── modules/                        # Terraform modules
│   └── minikube/
│       ├── main.tf                 # Minikube cluster setup
│       ├── variables.tf
│       └── outputs.tf
└── k8s/                           # Kubernetes manifests
    ├── base/                      # Base configurations
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

## Architecture Components

- **Terraform**: Infrastructure as Code for cluster provisioning
- **Minikube**: Local Kubernetes cluster
- **Argo CD**: GitOps continuous deployment
- **Kustomize**: Configuration management and overlays

## Clean Up

To destroy all resources and stop the Minikube cluster:

```bash
cd infra
terraform destroy
```

This will remove:
- Minikube cluster
- Argo CD installation
- All GitOps applications and configurations

## Troubleshooting

### Common Issues

1. **Docker not running**: Ensure Docker Desktop is started before running Terraform
2. **Port conflicts**: Check if required ports are available on your system
3. **Resource limits**: Adjust CPU and memory settings in `terraform.tfvars` if needed
4. **GitHub PAT permissions**: Ensure your PAT has appropriate repository access
