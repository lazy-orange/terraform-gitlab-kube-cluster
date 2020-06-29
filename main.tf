locals {
  sa_name      = "gitlab-admin"
  sa_namespace = "kube-system"

  environment_scope           = var.stage
  project_cluster_enabled     = var.enabled && length(var.root_gitlab_project) > 0 ? 1 : 0
  group_cluster_enabled       = var.enabled && length(var.root_gitlab_group) > 0 ? 1 : 0
  group_gitlab_runner_enabled = (var.group_gitlab_runner_enabled && length(var.root_gitlab_group) > 0) ? 1 : 0

  cluster_name = var.cluster_name
  domain       = var.dns_zone
}

# In the next steps we will add a few env variables to Gitlab CI variables
# to make possible run CI jobs that depends on these variables
data "gitlab_project" "root" {
  count = local.project_cluster_enabled
  id    = var.root_gitlab_project
}

data "gitlab_group" "root" {
  count    = length(var.root_gitlab_group) > 0 ? 1 : 0
  group_id = length(var.root_gitlab_group) > 0 ? var.root_gitlab_group : 0
}

module "gitlab_admin_sa" {
  source = "./modules/gitlab-admin-service-account"

  enabled = var.enabled

  kubernetes_endpoint = var.kubernetes_endpoint
  kubernetes_token    = var.kubernetes_token
  kubernetes_ca_cert  = var.kubernetes_ca_cert
}

# https://www.terraform.io/docs/providers/gitlab/r/project_cluster.html
data "kubernetes_secret" "gitlab_admin_token" {
  count = var.enabled ? 1 : 0

  metadata {
    name      = module.gitlab_admin_sa.sa_name
    namespace = local.sa_namespace
  }
}

resource "gitlab_project_cluster" "root" {
  count   = local.project_cluster_enabled
  project = join("", data.gitlab_project.root.*.id)

  name   = local.cluster_name
  domain = local.domain

  kubernetes_api_url = var.kubernetes_endpoint
  kubernetes_token   = join(",", data.kubernetes_secret.gitlab_admin_token.*.data.token)
  kubernetes_ca_cert = base64decode(var.kubernetes_ca_cert)

  environment_scope = local.environment_scope

  lifecycle {
    ignore_changes = [kubernetes_ca_cert]
  }
}

resource "gitlab_group_cluster" "root" {
  count = local.group_cluster_enabled

  group = join("", data.gitlab_group.root.*.id)

  name   = local.cluster_name
  domain = local.domain

  kubernetes_api_url = var.kubernetes_endpoint
  kubernetes_token   = join(",", data.kubernetes_secret.gitlab_admin_token.*.data.token)
  kubernetes_ca_cert = base64decode(var.kubernetes_ca_cert)

  ## You can use only one Kubernetes cluster per a group/project when your team uses a free plan on Gitlab.com
  ## If you will set explicitly env scope you can't use Auto DevOps feature
  ##
  ## References:
  ## - https://docs.gitlab.com/12.5/ee/topics/autodevops/index.html#overview
  ## - https://gitlab.com/gitlab-org/gitlab-foss/blob/master/lib/gitlab/ci/templates/Auto-DevOps.gitlab-ci.yml
  environment_scope = local.environment_scope

  lifecycle {
    ignore_changes = [kubernetes_ca_cert]
  }
}
