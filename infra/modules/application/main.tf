# App runtime namespace
resource "kubernetes_namespace" "app" {
  metadata {
    name = var.application_namespace
    labels = {
      "app.kubernetes.io/name"       = var.application_name
      "app.kubernetes.io/part-of"    = var.cluster_name # <- use cluster_name instead of a static project label
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }
}


# Register the repo in Argo CD (Secret in argocd namespace)
resource "kubernetes_secret" "argocd_repo_github_https" {
  metadata {
    name      = var.repo_secret_name
    namespace = var.argocd_namespace
    labels = {
      "argocd.argoproj.io/secret-type" = "repository"
      "app.kubernetes.io/part-of"      = var.cluster_name
      "app.kubernetes.io/managed-by"   = "terraform"
    }
  }
  type = "Opaque"

  # stringData lets us provide plaintext; provider encodes to data
  data = {
    type     = "git"
    url      = var.github_repo_url
    username = var.repo_username
    password = var.github_pat
  }
}

# AppProject (scopes repos/destinations)
resource "kubernetes_manifest" "argocd_project" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "AppProject"
    metadata = {
      name      = var.project_name
      namespace = var.argocd_namespace
      labels = {
        "app.kubernetes.io/part-of"    = var.cluster_name
        "app.kubernetes.io/managed-by" = "terraform"
      }
    }
    spec = {
      description = "Project for ${var.cluster_name}"
      sourceRepos = [var.github_repo_url]
      destinations = [{
        namespace = var.application_namespace
        server    = "https://kubernetes.default.svc"
      }]
      clusterResourceWhitelist   = [{ group = "*", kind = "*" }]
      namespaceResourceWhitelist = [{ group = "*", kind = "*" }]
    }
  }
}

# Argo CD Application
resource "kubernetes_manifest" "argocd_application" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = var.application_name
      namespace = var.argocd_namespace
      labels = {
        "app.kubernetes.io/part-of"    = var.cluster_name
        "app.kubernetes.io/managed-by" = "terraform"
      }
    }
    spec = {
      project = var.project_name
      source = {
        repoURL        = var.github_repo_url
        targetRevision = var.target_revision
        path           = var.kustomize_path
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = var.application_namespace
      }
      syncPolicy = {
        automated   = { prune = true, selfHeal = true }
        syncOptions = ["CreateNamespace=true"]
      }
    }
  }
}
