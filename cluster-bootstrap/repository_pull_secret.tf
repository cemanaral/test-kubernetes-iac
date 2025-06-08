locals {
  namespace = "app"
}

resource "kubernetes_namespace" "app_namespace" {
  metadata {
    name = local.namespace
  }
}

resource "kubernetes_secret" "repository_pull_secret" {
  for_each = toset(["jenkins", "app"]) # creating for both jenkins and app namespaces
  metadata {
    name = "dockerhub-image-pull-secret"
    namespace = each.key
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
  depends_on = [ kubernetes_namespace.app_namespace, kubernetes_namespace.jenkins ]
}