resource "azurerm_service_plan" "asp_zkoo_01" {
  name                = "asp-zkoo-01"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "app_zkoo_02" {
  name                          = "app-zkoo-02"
  resource_group_name           = data.azurerm_resource_group.rg.name
  location                      = data.azurerm_resource_group.rg.location
  service_plan_id               = azurerm_service_plan.asp_zkoo_01.id
  https_only                    = true
  public_network_access_enabled = false

  site_config {
    minimum_tls_version = "1.2"
    ftps_state          = "Disabled"
  }
}

resource "azurerm_linux_web_app" "app_zkoo_03" {
  name                = "app-zkoo-03"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  service_plan_id     = azurerm_service_plan.asp_zkoo_01.id
  https_only          = true

  site_config {
    minimum_tls_version           = "1.2"
    ftps_state                    = "Disabled"
    ip_restriction_default_action = "Deny"
    ip_restriction {
      name       = "allow-proxy"
      priority   = 100
      action     = "Allow"
      ip_address = "${azurerm_public_ip.pip_proxy.ip_address}/32"
    }
  }


}