# ------------------------------------------------------------------------------
# Application Namespace
# ------------------------------------------------------------------------------
resource "kubernetes_namespace" "app" {
  metadata {
    name = var.application_namespace
    labels = {
      "app.kubernetes.io/name"       = var.application_name
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }
}

# ------------------------------------------------------------------------------
# Argo CD Repository Secret (only needed if repo is private)
# ------------------------------------------------------------------------------
resource "kubernetes_secret" "argocd_repo" {
  metadata {
    name      = var.repo_secret_name
    namespace = var.argocd_namespace
    labels = {
      "argocd.argoproj.io/secret-type" = "repository"
    }
  }

  type = "Opaque"

  # Use `stringData` to allow plaintext (Terraform auto-encodes to base64)
  data = {
    type     = "git"
    url      = var.github_repo_url
    username = var.repo_username
    password = var.github_pat
  }
}

# ------------------------------------------------------------------------------
# Argo CD Project
# ------------------------------------------------------------------------------
resource "kubectl_manifest" "argocd_project" {
  yaml_body = <<-YAML
    apiVersion: argoproj.io/v1alpha1
    kind: AppProject
    metadata:
      name: ${var.project_name}
      namespace: ${var.argocd_namespace}
    spec:
      description: Project for ${var.application_name}
      sourceRepos:
        - "*"
      destinations:
        - namespace: "*"
          server: "*"
      clusterResourceWhitelist:
        - group: "*"
          kind: "*"
  YAML
}

# ------------------------------------------------------------------------------
# Argo CD Application (deploys via Kustomize)
# ------------------------------------------------------------------------------
resource "kubectl_manifest" "argocd_application" {
  yaml_body = <<-YAML
    apiVersion: argoproj.io/v1alpha1
    kind: Application
    metadata:
      name: ${var.application_name}
      namespace: ${var.argocd_namespace}
    spec:
      project: ${var.project_name}
      source:
        repoURL: ${var.github_repo_url}
        targetRevision: ${var.target_revision}
        path: ${var.kustomize_path}
      destination:
        server: https://kubernetes.default.svc
        namespace: ${var.application_namespace}
      syncPolicy:
        automated:
          prune: true
          selfHeal: true
        syncOptions:
          - CreateNamespace=true
  YAML

  depends_on = [
    kubectl_manifest.argocd_project,
    kubernetes_secret.argocd_repo
  ]
}
