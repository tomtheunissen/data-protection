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