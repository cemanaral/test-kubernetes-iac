terraform {
  required_providers {
    null = {
      source = "hashicorp/null"
      version = "3.2.4"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.37.1"
    }
  }
}

provider "null" {}

provider "kubernetes" {
  config_path = "~/.kube/config"
  config_context = "minikube"
}
