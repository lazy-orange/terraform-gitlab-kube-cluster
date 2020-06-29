variable "enabled" {
  type    = bool
  default = true
}

variable "stage" {
  type        = string
  description = "(Required) Stage, e.g. 'prod', 'staging', 'dev' or 'testing'"
}

variable "dns_zone" {
  type        = string
  description = "(Required) specifies the DNS suffix for the externally-visible websites and services deployed in the cluster"
}

variable "cluster_name" {
  type = string
}

variable "group_gitlab_runner_enabled" {
  type        = bool
  description = "(Optional) Setup a gitlab group runner (will be used a group runner token to set GITLAB_RUNNER_TOKEN env variable)"
  default     = false
}

variable "root_gitlab_group" {
  type        = string
  default     = ""
  description = "(Semi-optional) A gitlab group id attach Kubernetes cluster to"
}

variable "root_gitlab_project" {
  type        = string
  default     = ""
  description = "(Semi-optional) A gitlab project id attach Kubernetes cluster to"
}

variable "kubernetes_endpoint" {
  type        = string
  description = "(Required) The hostname (in form of URI) of Kubernetes master."
}

variable "kubernetes_token" {
  type        = string
  description = "(Required) Token of your service account, must have admin permission to create another service accounts"
}

variable "kubernetes_ca_cert" {
  type        = string
  description = "(Required) PEM-encoded root certificates bundle for TLS authentication"
}
