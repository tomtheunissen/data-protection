resource "azurerm_dev_test_global_vm_shutdown_schedule" "shutdown" {
  for_each              = local.vms
  virtual_machine_id    = azurerm_linux_virtual_machine.vm[each.key].id
  location              = data.azurerm_resource_group.rg.location
  enabled               = true
  daily_recurrence_time = "1900"
  timezone              = "W. Europe Standard Time"

  notification_settings {
    enabled = false
  }
}

resource "azurerm_log_analytics_workspace" "log" {
  name                = "log-zkoo-01"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_mssql_server_extended_auditing_policy" "sql" {
  server_id              = azurerm_mssql_server.sql.id
  log_monitoring_enabled = true
}

resource "azurerm_monitor_diagnostic_setting" "sql" {
  name                       = "diag-sql-zkoo-01"
  target_resource_id         = "${azurerm_mssql_server.sql.id}/databases/master"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log.id

  enabled_log {
    category = "SQLSecurityAuditEvents"
  }
}

resource "azurerm_monitor_diagnostic_setting" "file" {
  name                       = "diag-st-file"
  target_resource_id         = "${azurerm_storage_account.st.id}/fileServices/default"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log.id

  enabled_log {
    category_group = "allLogs"
  }
}