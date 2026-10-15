terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.5"
    }

    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }

  # Shared state in a separate storage account (created with the Azure CLI, not managed here)
  backend "azurerm" {
    subscription_id      = "91760767-8ba3-4fab-9b01-fe9df3819f4b"
    resource_group_name  = "2026_KE06_KDB1_casusgroep_04"
    storage_account_name = "stzkootfstate01"
    container_name       = "tfstate"
    key                  = "zkoo.tfstate"
  }
}