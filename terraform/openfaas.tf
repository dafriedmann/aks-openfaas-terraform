# Helm provider
provider "helm" {
  kubernetes {
      config_path = "${local_file.kubeconfig.filename}"
  }
}

# Add helm repo for OpenFaaS
data "helm_repository" "openfaas-repo" {
    name = "openfaas-repo"
    url  = "https://openfaas.github.io/faas-netes"
}

# Secret for OpenFaaS login
resource "kubernetes_secret" "openfaas-ui-auth" {
  metadata {
    name = "basic-auth"
    namespace = "openfaas"
  }

  # OpenFaaS expects the key "basic-auth-user" and " basic-auth-password".
  # Only "user" or "password" do not work here.
  data {
    basic-auth-user = "${var.of-username}"
    basic-auth-password = "${var.of-password}"
  }

  depends_on = ["kubernetes_namespace.openfaas"]
  depends_on = ["azurerm_kubernetes_cluster.k8-openfaas-aks"]
}

# Install OpenFaaS
resource "helm_release" "openfaas-release" {
    name       = "openfaas-repo"
    repository = "${data.helm_repository.openfaas-repo.metadata.0.name}"
    chart      = "openfaas"
    namespace = "openfaas"

    set{
        name = "functionNamespace"
        value = "openfaas-fn"
    }

    set{
        name = "basic_auth"
        value = "true"
    }

    set{
        name = "serviceType"
        value = "LoadBalancer"
    }

    depends_on = ["kubernetes_namespace.openfaas"]
    depends_on = ["kubernetes_namespace.openfaas-fn"]
    depends_on = ["kubernetes_secret.openfaas-ui-auth"]
}

# Setup complete
output "kube_config" {
  value = "AKS and OpenFaaS were successfully created. Via k8-Dashboard you can now find the public ip of the external gateway of OpenFaaS to deploy new functions."
}
