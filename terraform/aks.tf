# Azure provider
provider "azurerm" {
  version = "=1.27.1" 
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}

# Create resource group
resource "azurerm_resource_group" "k8-openfaas" {
  name     = "${var.rg_name}"
  location = "${var.location}"
}

# Create AKS (Kubernetes)
resource "azurerm_kubernetes_cluster" "k8-openfaas-aks" {
  name                = "${var.aks_name}"
  location            = "${azurerm_resource_group.k8-openfaas.location}"
  resource_group_name = "${azurerm_resource_group.k8-openfaas.name}"
  dns_prefix          = "${var.aks_name}"

  agent_pool_profile {
    name            = "default"
    count           = 1 # 1 Cluster-Node
    vm_size         = "Standard_D1_v2"
    os_type         = "Linux"
    os_disk_size_gb = 30
  }

  service_principal {
    client_id     = "${var.client_id}"
    client_secret = "${var.client_secret}"
  }

  tags = {
    Environment = "Development"
  }
}

# Save kubeconfig
# Here we note the connection details which are necessary for operations on the created K8.
resource "local_file" "kubeconfig" {
  content  = "${azurerm_kubernetes_cluster.k8-openfaas-aks.kube_config_raw}"
  filename = "./kubeconfig"
}
provider "kubernetes" {
    config_path = "${local_file.kubeconfig.filename}"
}

# Creating the necessary OpenFaaS namespaces
# https://raw.githubusercontent.com/openfaas/faas-netes/master/namespaces.yml
resource "kubernetes_namespace" "openfaas" {
  metadata {
    name = "openfaas"
    labels{
      role = "openfaas-system"
      access = "openfaas-system"
      istio-injection = "enabled"
    }
  }
  depends_on = ["azurerm_kubernetes_cluster.k8-openfaas-aks"]
}

resource "kubernetes_namespace" "openfaas-fn" {
  metadata {
    name = "openfaas-fn"
    labels{
      role = "openfaas-fn"
      istio-injection = "enabled"
    }
  }
  depends_on = ["azurerm_kubernetes_cluster.k8-openfaas-aks"]
}
