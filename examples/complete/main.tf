data "digitalocean_kubernetes_versions" "default" {
  version_prefix = "1.16"
}

data "digitalocean_sizes" "default" {
  filter {
    key    = "memory"
    values = [2048, 3072, 4096]
  }

  filter {
    key    = "regions"
    values = ["fra1"]
  }

  sort {
    key       = "price_monthly"
    direction = "asc"
  }
}

resource "digitalocean_kubernetes_cluster" "default" {
  region = "fra1"

  name    = "examples-complete"
  version = data.digitalocean_kubernetes_versions.default.latest_version

  node_pool {
    name       = "main"
    size       = element(data.digitalocean_sizes.default.sizes, 0).slug
    node_count = 1
    min_nodes  = 1
    max_nodes  = 1
  }
}

module "example" {
  source = "../.."

  stage        = "dev"
  cluster_name = "terraform-gitlab-kube-cluster"
  dns_zone     = "terraform-gitlab-kube-cluster.example.com"

  # https://gitlab.com/lazyorangejs/lab
  root_gitlab_group = var.root_gitlab_group # should point to your own gitlab group

  kubernetes_endpoint = digitalocean_kubernetes_cluster.default.endpoint
  kubernetes_token    = digitalocean_kubernetes_cluster.default.kube_config[0].token
  kubernetes_ca_cert  = digitalocean_kubernetes_cluster.default.kube_config[0].cluster_ca_certificate
}
