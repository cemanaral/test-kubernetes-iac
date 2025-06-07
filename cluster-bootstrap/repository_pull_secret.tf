locals {
  namespace = "app"
}

resource "kubernetes_namespace" "app_namespace" {
  metadata {
    name = local.namespace
  }
}

resource "kubernetes_secret" "repository_pull_secret" {
  metadata {
    name = "dockerhub-image-pull-secret"
    namespace = local.namespace
  }
  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "https://index.docker.io/v1/" = {
          "username" = "cemanaral425383"
          "password" = file(".dockerhub-token")
        }
      }
    })
  }
}