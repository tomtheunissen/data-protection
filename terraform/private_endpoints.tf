resource "azurerm_private_dns_zone" "sql" {
  name                = "privatelink.database.windows.net"
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "link_sql_vnet_zkoo_01" {
  name                = "link-sql-vnet-zkoo-01"
  private_dns_zone_id = azurerm_private_dns_zone.sql.id
  virtual_network_id  = azurerm_virtual_network.vnet.id
}


resource "azurerm_private_dns_zone" "webapp" {
  name                = "privatelink.azurewebsites.net"
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "link_webapp_vnet_zkoo_01" {
  name                = "link-webapp-vnet-zkoo-01"
  private_dns_zone_id = azurerm_private_dns_zone.webapp.id
  virtual_network_id  = azurerm_virtual_network.vnet.id
}


resource "azurerm_private_dns_zone" "file" {
  name                = "privatelink.file.core.windows.net"
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "link_file_vnet_zkoo_01" {
  name                = "link-file-vnet-zkoo-01"
  private_dns_zone_id = azurerm_private_dns_zone.file.id
  virtual_network_id  = azurerm_virtual_network.vnet.id
}

resource "azurerm_private_endpoint" "sql" {
  name                = "pep-sql"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  subnet_id           = azurerm_subnet.snet_pep.id

  private_service_connection {
    name                           = "psc-sql"
    private_connection_resource_id = azurerm_mssql_server.sql.id
    subresource_names              = ["sqlServer"]
    is_manual_connection           = false
  }

  ip_configuration {
    name               = "ipconfig-sql"
    private_ip_address = local.pep_sql_ip
    subresource_name   = "sqlServer"
    member_name        = "sqlServer"
  }

  private_dns_zone_group {
    name                 = "dns-sql"
    private_dns_zone_ids = [azurerm_private_dns_zone.sql.id]
  }
}

resource "azurerm_private_endpoint" "webapp" {
  name                = "pep-webapp"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  subnet_id           = azurerm_subnet.snet_pep.id

  private_service_connection {
    name                           = "psc-webapp"
    private_connection_resource_id = azurerm_linux_web_app.app_zkoo_02.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }

  ip_configuration {
    name               = "ipconfig-webapp"
    private_ip_address = local.pep_webapp_ip
    subresource_name   = "sites"
    member_name        = "sites"
  }

  private_dns_zone_group {
    name                 = "dns-webapp"
    private_dns_zone_ids = [azurerm_private_dns_zone.webapp.id]
  }
}

resource "azurerm_private_endpoint" "sensitivedata" {
  name                = "pep-sensitivedata"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  subnet_id           = azurerm_subnet.snet_pep.id

  private_service_connection {
    name                           = "psc-sensitivedata"
    private_connection_resource_id = azurerm_storage_account.st.id
    subresource_names              = ["file"]
    is_manual_connection           = false
  }

  ip_configuration {
    name               = "ipconfig-sensitivedata"
    private_ip_address = local.pep_sensitivedata_ip
    subresource_name   = "file"
    member_name        = "file"
  }

  private_dns_zone_group {
    name                 = "dns-sensitivedata"
    private_dns_zone_ids = [azurerm_private_dns_zone.file.id]
  }
}