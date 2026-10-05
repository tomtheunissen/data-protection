resource "azurerm_mssql_server" "sql" {
  name                          = "sql-zkoo-01"
  resource_group_name           = data.azurerm_resource_group.rg.name
  location                      = data.azurerm_resource_group.rg.location
  version                       = "12.0"
  minimum_tls_version           = "1.2"
  public_network_access_enabled = false

  azuread_administrator {
    login_username              = var.sql_admin_login
    object_id                   = var.sql_admin_object_id
    azuread_authentication_only = true
  }
}

resource "azurerm_mssql_database" "db" {
  name      = "sqldb-zkoo-01"
  server_id = azurerm_mssql_server.sql.id
  sku_name  = "Basic"
}