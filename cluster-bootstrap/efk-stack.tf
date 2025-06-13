locals {
  efk_namespace = "efk"
}

resource "kubernetes_namespace" "efk" {
  metadata {
    name = local.efk_namespace
  }
}

resource "helm_release" "elasticsearch" {
  name             = "elasticsearch"
  repository       = "https://helm.elastic.co"
  create_namespace = false
  namespace        = local.efk_namespace
  chart            = "elasticsearch"
  version          = "8.5.1"
  values           = [file("./elasticsearch-values.yaml")]
  depends_on = [ kubernetes_namespace.efk ]
}

resource "helm_release" "kibana" {
  name             = "kibana"
  repository       = "https://helm.elastic.co"
  create_namespace = false
  namespace        = local.efk_namespace
  chart            = "kibana"
  version          = "8.5.1"
  values           = [file("./kibana-values.yaml")]
  depends_on = [ helm_release.elasticsearch ]
}