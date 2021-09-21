//################# Setup kube context #################
//
//## Get credentials for AWS
////
//resource "null_resource" "setup_context" {
//  provisioner "local-exec" {
//    command = "aws eks --region ${var.region} update-kubeconfig --name ${var.cluster_name}"
//  }
//
//}

resource "null_resource" "install_ebs_csi_driver" {
  provisioner "local-exec" {
    command = "kubectl apply -k \"github.com/kubernetes-sigs/aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/?ref=release-1.2\""
  }

  depends_on = [module.eks]
}

resource "null_resource" "install_efs_csi_driver" {
  provisioner "local-exec" {
    command = "kubectl apply -k \"github.com/kubernetes-sigs/aws-efs-csi-driver/deploy/kubernetes/overlays/stable/?ref=release-1.3\""
  }

  depends_on = [module.eks]
}

## Create prod namespace

resource "kubernetes_namespace" "prod" {

  metadata {
    name = "prod"
  }

  depends_on = [module.eks]
}

################# Setup registry secret #################

## Update template config.json file

data "template_file" "docker_config_script" {
  template = "${file("${path.module}/config.json")}"
  vars = {
    docker-server             = "${var.docker-server}"
    auth                      = base64encode("${var.docker-username}:${var.docker-password}")
  }
}

## Create kubernetes secret from template file

resource "kubernetes_secret" "docker-registry" {
  metadata {
    name = "regcred"
    namespace = "prod"
  }

  data = {
    ".dockerconfigjson" = "${data.template_file.docker_config_script.rendered}"
  }

  type = "kubernetes.io/dockerconfigjson"

  depends_on = [kubernetes_namespace.prod]
}

################# ArangoDB install #################

## Install arango-crd

resource "helm_release" "arango-crd" {

  name  = "arango-crd"
  chart = "https://github.com/arangodb/kube-arangodb/releases/download/1.0.3/kube-arangodb-crd-1.0.3.tgz"
  namespace = "prod"

  depends_on = [kubernetes_namespace.prod]
}

## Install arango-oper

resource "helm_release" "arango-oper" {

  name  = "arango-oper"
  chart = "https://github.com/arangodb/kube-arangodb/releases/download/1.0.3/kube-arangodb-1.0.3.tgz"
  namespace = "prod"

  depends_on = [kubernetes_namespace.prod]

  set {
    name = "operator.features.storage"
    value = "true"
  }

  set {
    name = "operator.service.type"
    value = "NodePort"
  }

  set {
    name = "DeploymentReplication.Create"
    value = "false"
  }

  set {
    name = "spec.auth.jwtSecretName"
    value = "None"
  }

  set {
    name = "spec.auth.jwtSecretName"
    value = "None"
  }

  set {
    name = "spec.tls.caSecretName"
    value = "None"
  }

}

################# Cert manager install #################

## Create cert-manager namespace

resource "kubernetes_namespace" "cert-manager" {

  metadata {
    name = "cert-manager"
  }

  depends_on = [module.eks]
}

## Install cert manager CRD

resource "null_resource" "cert_manager_apply" {
  provisioner "local-exec" {
      command = "kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v0.16.1/cert-manager.crds.yaml"
    }

  depends_on = [kubernetes_namespace.cert-manager]
}

## Install cert manager

resource "helm_release" "cert-manager" {
    name      = "cert-manager"
    namespace = "cert-manager"
    chart     = "jetstack/cert-manager"
    version   = "v0.16.1"

    depends_on = [null_resource.cert_manager_apply]
}

################# Ingress install #################

## Install ingress

resource "null_resource" "ingress_install" {
  provisioner "local-exec" {
    command = "kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.43.0/deploy/static/provider/aws/deploy.yaml"
  }

  depends_on = [null_resource.cert_manager_apply]
}

//################# IzChart install #################

resource "helm_release" "izchart" {
  //chart = "https://helm.inzata.com/charts/izchart-0.6.22.tgz"
  chart = "http://inzata-helm-chart.s3-website.us-east-2.amazonaws.com/charts/izchart-0.6.25.tgz"
  name = "izchart"
  namespace = "prod"
  timeout = var.iz_timeout

  values = [yamlencode(local.izchart_values)]

  depends_on = [kubernetes_namespace.prod, helm_release.arango-crd, helm_release.arango-oper, helm_release.cert-manager,kubernetes_secret.docker-registry]
}

################# Setup domain certificate #################

data "template_file" "ssl_config" {
  template = "${file("${path.cwd}/ssl.yaml")}"
  vars = {
    ssl_mail = var.ssl_mail
    ssl_domain = var.ssl_domain
  }

  depends_on = [helm_release.izchart]

}

resource "null_resource" "apply_certificate" {
  provisioner "local-exec" {
    command = "kubectl apply -f -<<EOF\n${data.template_file.ssl_config.rendered}\nEOF"
  }

  depends_on = [data.template_file.ssl_config]
}
