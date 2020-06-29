variable "root_gitlab_group" {
  type        = string
  description = "(Required) A gitlab group id attach Kubernetes cluster to"
}

variable "gitlab_token" {
  type = string
}

variable "do_token" {
  type = string
}
