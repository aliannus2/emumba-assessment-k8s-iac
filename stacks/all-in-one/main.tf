locals {
  cluster_dir     = "../../projects/cluster"
  argocd_dir      = "../../projects/argocd"
  application_dir = "../../projects/application"
}

# 1) Cluster INIT
resource "null_resource" "cluster_init" {
  triggers = {
    dir  = local.cluster_dir
    bump = "1"
  }
  provisioner "local-exec" {
    command = "terraform -chdir=${self.triggers.dir} init -upgrade"
  }
}

# 1) Cluster APPLY
resource "null_resource" "cluster_apply" {
  triggers = {
    init_done = null_resource.cluster_init.id
    dir       = local.cluster_dir
    bump      = "1"
  }
  provisioner "local-exec" {
    command = "terraform -chdir=${self.triggers.dir} apply -auto-approve"
  }
  provisioner "local-exec" {
    when    = destroy
    command = "terraform -chdir=${self.triggers.dir} destroy -auto-approve"
  }
}

# 2) Argo CD INIT
resource "null_resource" "argocd_init" {
  triggers = {
    cluster_done = null_resource.cluster_apply.id
    dir          = local.argocd_dir
    bump         = "1"
  }
  provisioner "local-exec" {
    command = "terraform -chdir=${self.triggers.dir} init -upgrade"
  }
}

# 2) Argo CD APPLY
resource "null_resource" "argocd_apply" {
  triggers = {
    init_done = null_resource.argocd_init.id
    dir       = local.argocd_dir
    bump      = "1"
  }
  provisioner "local-exec" {
    command = "terraform -chdir=${self.triggers.dir} apply -auto-approve"
  }
  provisioner "local-exec" {
    when    = destroy
    command = "terraform -chdir=${self.triggers.dir} destroy -auto-approve"
  }
}

# 3) Application INIT
resource "null_resource" "application_init" {
  triggers = {
    argocd_done = null_resource.argocd_apply.id
    dir         = local.application_dir
    bump        = "1"
  }
  provisioner "local-exec" {
    command = "terraform -chdir=${self.triggers.dir} init -upgrade"
  }
}

# 3) Application APPLY
resource "null_resource" "application_apply" {
  triggers = {
    init_done = null_resource.application_init.id
    dir       = local.application_dir
    bump      = "1"
  }
  provisioner "local-exec" {
    command = "terraform -chdir=${self.triggers.dir} apply -auto-approve -var='github_repo_url=${var.github_repo_url}' -var='github_pat=${var.github_pat}'"
  }
  provisioner "local-exec" {
    when    = destroy
    command = "terraform -chdir=${self.triggers.dir} destroy -auto-approve"
  }
}
