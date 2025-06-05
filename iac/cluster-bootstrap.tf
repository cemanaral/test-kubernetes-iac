locals {
  namespace = "app"
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

resource "kubernetes_namespace" "app_namespace" {
  metadata {
    name = local.namespace
  }
}

resource "kubernetes_deployment" "nginx_deployment" {
  metadata {
    name      = "nginx-example"
    namespace = local.namespace
    labels = {
      app = "nginx"
    }
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "nginx"
      }
    }
    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }
      spec {
        container {
          name  = "nginx"
          image = "cemanaral425383/test-python-app:nginx-alpine"
          port {
            container_port = 80
          }
        }
        image_pull_secrets {
            name = "dockerhub-image-pull-secret"
        }
      }
    }
  }
}
