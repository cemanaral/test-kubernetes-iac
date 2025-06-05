locals {
  kubernetes_version = "1.32.5"
}

resource "null_resource" "minikube_cluster" {
  provisioner "local-exec" {
    when    = create
    command = "minikube start --kubernetes-version='${local.kubernetes_version}'"
  }
  provisioner "local-exec" {
    when    = destroy
    command = "minikube delete"
  }
  triggers = {
    kubernetes_version = local.kubernetes_version
  }
}

