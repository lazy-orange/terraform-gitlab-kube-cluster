provider "gitlab" {
  token = var.gitlab_token
}

provider "digitalocean" {
  token = var.do_token
}
