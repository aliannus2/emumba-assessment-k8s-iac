terraform {
  required_version = ">= 1.10.0"
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.38.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "3.0.2"
    }
  }
}

provider "kubernetes" {
  config_path = pathexpand("~/.kube/config")
}

provider "helm" {
  kubernetes = {
    config_path = pathexpand("~/.kube/config")
  }
}


resource "kubernetes_namespace" "argocd" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/name"       = "argocd"
      "app.kubernetes.io/part-of"    = "emumba-assessment-k8s-iac"
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }
}

resource "helm_release" "argocd" {
  name       = var.release_name
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = kubernetes_namespace.argocd.metadata[0].name
  version    = "8.5.7"

  values = [yamlencode({
    configs = {
      params = {
        "server.insecure" = "true"
      }
    }
    server = {
      service = {
        type = var.server_service_type
      }
    }
  })]

  depends_on = [kubernetes_namespace.argocd]
}

# Repo credential (HTTPS + PAT)
resource "kubernetes_secret" "argocd_repo_github_https" {
  metadata {
    name      = "repo-github-emumba-https"
    namespace = kubernetes_namespace.argocd.metadata[0].name
    labels = { "argocd.argoproj.io/secret-type" = "repository" }
  }
  type = "Opaque"
  data = {
    type     = "git"
    url      = var.github_repo_url
    username = "git"
    password = var.github_pat
  }
}

# AppProject that your Application references
resource "kubernetes_manifest" "emumba_project" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "AppProject"
    metadata = {
      name      = "emumba-deployment"
      namespace = kubernetes_namespace.argocd.metadata[0].name
      labels = { "app.kubernetes.io/part-of" = "emumba-assessment-k8s-iac" }
    }
    spec = {
      description = "Project for Emumba assessment"
      sourceRepos = [var.github_repo_url] # or ["*"]
      destinations = [{
        namespace = "emumba-assessment"
        server    = "https://kubernetes.default.svc"
      }]
      clusterResourceWhitelist   = [{ group = "*", kind = "*" }]
      namespaceResourceWhitelist = [{ group = "*", kind = "*" }]
    }
  }
  depends_on = [helm_release.argocd]
}

# Application that deploys your Kustomize overlay
resource "kubernetes_manifest" "app" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "emumba-assessment-app"
      namespace = kubernetes_namespace.argocd.metadata[0].name
      labels = { "app.kubernetes.io/part-of" = "emumba-assessment-k8s-iac" }
    }
    spec = {
      project = "emumba-deployment"
      source = {
        repoURL        = var.github_repo_url
        targetRevision = "local-exec-minikube"
        path           = "k8s/overlays/dev"
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = "emumba-assessment"
      }
      syncPolicy = {
        automated  = { prune = true, selfHeal = true }
        syncOptions = ["CreateNamespace=true"]
      }
    }
  }
  depends_on = [
    helm_release.argocd,
    kubernetes_manifest.emumba_project,
    kubernetes_secret.argocd_repo_github_https
  ]
}
