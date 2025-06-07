locals {
  namespace = "app"
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
