terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.5"
    }
  }
}

provider "azurerm" {
  features {}
  resource_provider_registrations = "none"
  subscription_id                 = "91760767-8ba3-4fab-9b01-fe9df3819f4b"
}

data "azurerm_resource_group" "rg" {
  name = "2026_KE06_KDB1_casusgroep_04"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-zkoo-01"
  address_space       = ["192.168.0.0/16"]
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "snet_edge" {
  name                 = "snet-edge"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["192.168.1.0/24"]
}

resource "azurerm_subnet" "snet_frontend" {
  name                 = "snet-frontend"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["192.168.4.0/22"]
}

resource "azurerm_subnet" "snet_backend" {
  name                 = "snet-backend"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["192.168.8.0/22"]
}

resource "azurerm_subnet" "snet_mgmt" {
  name                 = "snet-mgmt"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["192.168.13.0/28"]
}

resource "azurerm_subnet" "snet_pep" {
  name                              = "snet-pep"
  resource_group_name               = data.azurerm_resource_group.rg.name
  virtual_network_name              = azurerm_virtual_network.vnet.name
  address_prefixes                  = ["192.168.14.0/27"]
  private_endpoint_network_policies = "Enabled"
}

resource "azurerm_application_security_group" "asg_proxy" {
  name                = "asg-proxy"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_application_security_group" "asg_vpn" {
  name                = "asg-vpn"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_application_security_group" "asg_portal" {
  name                = "asg-portal"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_application_security_group" "asg_website" {
  name                = "asg-website"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_application_security_group" "asg_media" {
  name                = "asg-media"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_application_security_group" "asg_ftp" {
  name                = "asg-ftp"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_application_security_group" "asg_app" {
  name                = "asg-app"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_application_security_group" "asg_fs" {
  name                = "asg-fs"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_application_security_group" "asg_mgmt" {
  name                = "asg-mgmt"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

