resource "helm_release" "kube-prometheus-stack" {
  name             = "kube-prometheus-stack"
  repository       = "https://prometheus-community.github.io/helm-charts"
  create_namespace = true
  namespace        = "kube-prometheus-stack"
  chart            = "kube-prometheus-stack"
  version          = "74.0.0"
  values           = [file("./kube-prometheus-stack-values.yaml")]
}