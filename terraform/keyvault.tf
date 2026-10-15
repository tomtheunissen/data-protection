# Identity of whoever runs Terraform, used for the tenant ID and their own access policy
data "azurerm_client_config" "current" {}

# Stores VPN client profiles and the storage key, so no secrets end up in code or Git
resource "azurerm_key_vault" "kv" {
  name                       = "kv-zkoo-01"
  location                   = data.azurerm_resource_group.rg.location
  resource_group_name        = data.azurerm_resource_group.rg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  rbac_authorization_enabled = false
  soft_delete_retention_days = 7
  purge_protection_enabled   = false

  # Terraform runner: manages the secrets Terraform writes
  access_policy {
    tenant_id          = data.azurerm_client_config.current.tenant_id
    object_id          = data.azurerm_client_config.current.object_id
    secret_permissions = ["Get", "List", "Set", "Delete", "Recover", "Purge"]
  }

  # Jump host: writes the VPN client profiles and reads the storage key
  access_policy {
    tenant_id          = data.azurerm_client_config.current.tenant_id
    object_id          = azurerm_linux_virtual_machine.vm["mgmt-01"].identity[0].principal_id
    secret_permissions = ["Get", "List", "Set"]
  }

  # Patient portal: only reads the storage key to mount the medical files share
  access_policy {
    tenant_id          = data.azurerm_client_config.current.tenant_id
    object_id          = azurerm_linux_virtual_machine.vm["web-01"].identity[0].principal_id
    secret_permissions = ["Get"]
  }

  # Team members download their own VPN profile; the runner is skipped to avoid a duplicate policy
  dynamic "access_policy" {
    for_each = toset([for id in var.team_object_ids : id if id != data.azurerm_client_config.current.object_id])
    content {
      tenant_id          = data.azurerm_client_config.current.tenant_id
      object_id          = access_policy.value
      secret_permissions = ["Get", "List"]
    }
  }
}

resource "azurerm_key_vault_secret" "storage_key" {
  name         = "storage-key-stzkoosensitive01"
  value        = azurerm_storage_account.st.primary_access_key
  key_vault_id = azurerm_key_vault.kv.id
}
