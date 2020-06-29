locals {
  sa_name = "gitlab-admin"
  sa_namespace = "kube-system"
}

# This module create a service account with admin permissions for Gitlab Kubernetes integration
#
# - https://gitlab.com/help/user/project/clusters/add_remove_clusters#add-existing-cluster
resource "kubernetes_service_account" "gitlab_admin_service_account" {
  count = var.enabled ? 1 : 0

  metadata {
    name      = local.sa_name
    namespace = local.sa_namespace
  }
}

resource "kubernetes_cluster_role_binding" "gitlab_admin_cluster_role_binding" {
  count = var.enabled ? 1 : 0

  metadata {
    name = local.sa_name
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "gitlab-admin"
    namespace = "kube-system"
  }
}

output "sa_name" {
  value = join(",", kubernetes_service_account.gitlab_admin_service_account.*.default_secret_name)
}

