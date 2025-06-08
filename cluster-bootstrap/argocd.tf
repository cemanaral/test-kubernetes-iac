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
  depends_on       = [kubernetes_namespace.argocd]
}

resource "kubernetes_manifest" "argocd_application" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "argocd-app"
      namespace = "argocd"
    }
    spec = {
      project = "default"
      source = {
        repoURL        = "git@github.com:cemanaral/test-kubernetes-argocd.git"
        targetRevision = "HEAD"
        path           = "helm-chart/app"
        # helm = {
        #   valueFiles = [
        #     "../../argocd-environments/nodejs-app/dev/values.yaml"
        #   ]
        # }
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = "app" # The target namespace where the application will be deployed
      }
      syncPolicy = {
        automated = {
          selfHeal = true
        }
        syncOptions = [
          "CreateNamespace=true"
        ]
      }
    }
  }
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
  depends_on = [ kubernetes_namespace.argocd ]
}
