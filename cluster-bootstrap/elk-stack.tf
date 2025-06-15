locals {
  elk_namespace = "elk"
}

resource "kubernetes_namespace" "elk" {
  metadata {
    name = local.elk_namespace
  }
}

resource "helm_release" "elasticsearch" {
  name             = "elasticsearch"
  repository       = "https://helm.elastic.co"
  create_namespace = false
  namespace        = local.elk_namespace
  chart            = "elasticsearch"
  version          = "8.5.1"
  values           = [file("./elasticsearch-values.yaml")]
  depends_on = [ kubernetes_namespace.elk ]
}

resource "helm_release" "kibana" {
  name             = "kibana"
  repository       = "https://helm.elastic.co"
  create_namespace = false
  namespace        = local.elk_namespace
  chart            = "kibana"
  version          = "8.5.1"
  values           = [file("./kibana-values.yaml")]
  depends_on = [ helm_release.elasticsearch ]
}

resource "helm_release" "logstash" {
  name             = "logstash"
  repository       = "https://helm.elastic.co"
  create_namespace = false
  namespace        = local.elk_namespace
  chart            = "logstash"
  version          = "8.5.1"
  values           = [file("./logstash-values.yaml")]
  depends_on = [ helm_release.elasticsearch ]
}