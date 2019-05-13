# Variables

# Name of the azure ressource group
variable "rg_name" {
    type = "string"
    default = "k8-openfaas"
}

# Name of the azure kubernetes (aks)
variable "aks_name" {
    type = "string"
    default = "k8-openfaas-aks"
}

# Location
variable "location" {
    type = "string"
    default = "westeurope"
}

# Connection details to Azure
# Create service principal for use with Terraform:  >> az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/YOUR_SUBSCRIPTION_ID" <<
# https://docs.microsoft.com/en-us/azure/virtual-machines/linux/terraform-install-configure
variable "subscription_id" {
    type = "string"
    default = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
}
variable "client_id" {
    type = "string"
    default = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
}
variable "client_secret" {
    type = "string"
    default = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
}
variable "tenant_id" {
    type = "string"
    default = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
}

# Credentials for the OpenFaaS UI
variable "of-username" {
    type = "string"
    default = "CHANGE_USERNAME_HERE"
}
variable "of-password" {
    type = "string"
    default = "CHANGE_PASSWORD_HERE"
}
