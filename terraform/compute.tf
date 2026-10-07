resource "azurerm_network_interface" "nic" {
  for_each              = local.vms
  name                  = "nic-${each.key}"
  location              = data.azurerm_resource_group.rg.location
  resource_group_name   = data.azurerm_resource_group.rg.name
  ip_forwarding_enabled = each.value.ip_forwarding

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = each.value.subnet_id
    private_ip_address_allocation = "Static"
    private_ip_address            = each.value.ip
    public_ip_address_id          = each.value.pip_id
  }
}

resource "azurerm_network_interface_application_security_group_association" "nic_asg" {
  for_each                      = { for k, v in local.vms : k => v if v.has_asg }
  network_interface_id          = azurerm_network_interface.nic[each.key].id
  application_security_group_id = each.value.asg_id
}

resource "azurerm_linux_virtual_machine" "vm" {
  for_each              = local.vms
  name                  = "vm-${each.key}"
  location              = data.azurerm_resource_group.rg.location
  resource_group_name   = data.azurerm_resource_group.rg.name
  size                  = each.value.size
  admin_username        = var.admin_username
  network_interface_ids = [azurerm_network_interface.nic[each.key].id]

  # One key block per public key file in ssh-keys/, so every team member can log in
  dynamic "admin_ssh_key" {
    for_each = fileset("${path.module}/ssh-keys", "*.pub")
    content {
      username   = var.admin_username
      public_key = file("${path.module}/ssh-keys/${admin_ssh_key.value}")
    }
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }
}
