locals {
  argocd_namespace = "argocd"
}


resource "kubernetes_namespace" "argocd" {
  metadata {
    name = local.argocd_namespace
  }
}

resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  create_namespace = false
  namespace        = local.argocd_namespace
  chart            = "argo-cd"
  version          = "7.5.2"
  values           = [file("./argocd-values.yaml")]

  depends_on = [kubernetes_namespace.argocd]
}

resource "null_resource" "argocd_application" {
  provisioner "local-exec" {
    when    = create
    command = "kubectl apply -f argocd-application.yaml"
  }
  provisioner "local-exec" {
    when    = destroy
    command = "kubectl delete -f argocd-application.yaml"
  }
  depends_on = [ helm_release.argocd ]
}


resource "kubernetes_secret" "argocd-github-ssh-key" {
  metadata {
    name      = "argocd-github-ssh-key"
    namespace = local.argocd_namespace
    labels = {
      "argocd.argoproj.io/secret-type" = "repository"
    }
  }
  type = "Opaque"
  data = {
    url           = "git@github.com:cemanaral/test-kubernetes-argocd.git"
    sshPrivateKey = file("test-kubernetes.private")
  }
  depends_on = [kubernetes_namespace.argocd]
}
