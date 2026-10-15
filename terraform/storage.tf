resource "azurerm_storage_account" "st" {
  name                            = "stzkoosensitive01"
  resource_group_name             = data.azurerm_resource_group.rg.name
  location                        = data.azurerm_resource_group.rg.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  min_tls_version                 = "TLS1_2"
  https_traffic_only_enabled      = true
  public_network_access           = "Disabled"
  allow_nested_items_to_be_public = false

  share_properties {
    retention_policy {
      days = 7
    }
  }
}

resource "azurerm_storage_share" "medical" {
  name               = "medical-files"
  storage_account_id = azurerm_storage_account.st.id
  quota              = 10
}