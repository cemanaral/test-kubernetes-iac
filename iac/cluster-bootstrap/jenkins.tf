resource "helm_release" "jenkins" {
  name             = "jenkins"
  repository       = "https://charts.jenkins.io"
  create_namespace = true
  namespace        = "jenkins"
  chart            = "jenkins"
  version          = "5.8.56"
  values           = [file("./helm-values/jenkins-values.yaml")]
}
