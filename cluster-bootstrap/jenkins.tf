locals {
  jenkins_namespace = "jenkins"
}

resource "kubernetes_namespace" "jenkins" {
  metadata {
    name = local.jenkins_namespace
  }
}

resource "kubernetes_secret" "github_auth_ssh_key" {
  metadata {
    name      = "github-auth-ssh-key"
    namespace = local.jenkins_namespace
  }
  type = "generic"

  data = {
    "ssh-private-key" = file("test-kubernetes.private")
  }
  depends_on = [ kubernetes_namespace.jenkins ]
}

resource "helm_release" "jenkins" {
  name             = "jenkins"
  repository       = "https://charts.jenkins.io"
  create_namespace = false
  namespace        = "jenkins"
  chart            = "jenkins"
  version          = "5.8.56"
  values           = [file("./helm-values/jenkins-values.yaml")]
  depends_on = [ kubernetes_secret.github_auth_ssh_key ]
}
