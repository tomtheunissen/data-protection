provider "azurerm" {
    features {}
    resource_provider_registrations = "none"
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