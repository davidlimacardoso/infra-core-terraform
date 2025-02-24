# https://medium.com/@rvisingh1221/install-nginx-ingress-controller-in-aws-eks-890dc9c4ff72
# Load values from the chart into the https://github.com/davidlimacardoso/k8s-infra-core/blob/master/helm/infra/aws/default-ingress-nginx-aws-acm.yml
data "http" "ingress_yml" {
  url = "https://raw.githubusercontent.com/davidlimacardoso/k8s-infra-core/refs/heads/master/helm/infra/aws/default-ingress-nginx-aws-acm.yml"
}

resource "helm_release" "ingress_nginx_jupter" {
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "ingress-nginx"
  create_namespace = true
  version          = "19.0.0"
  values           = [data.http.ingress_yml.response_body]

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-ssl-cert"
    value = aws_acm_certificate.cert.arn
    type  = "string"
  }
}
#
