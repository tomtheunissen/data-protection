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
}
