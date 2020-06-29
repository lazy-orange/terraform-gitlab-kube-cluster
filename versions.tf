terraform {
  required_version = ">= 0.12.0, < 0.13.0"

  required_providers {
    gitlab     = ">= 2.10"
    kubernetes = ">= 1.11"
  }
}
