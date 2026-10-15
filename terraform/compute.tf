# SSH key of the jump host; its public half goes on every VM so Ansible on vm-mgmt-01 can reach them
resource "tls_private_key" "mgmt" {
  algorithm = "ED25519"
}

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

  # Only the jump host gets a bootstrap script; it installs Ansible and configures the VPN server
  custom_data = each.key == "mgmt-01" ? base64encode(templatefile("${path.module}/cloud-init/mgmt.yaml.tftpl", {
    admin_username = var.admin_username
    key_vault_name = local.key_vault_name
    repo_url       = var.repo_url
    vpn_ip         = local.vpn_ip
    inventory      = local.ansible_inventory
  })) : null

  # One key block per team member's public key in ssh-keys/, plus the jump host key for Ansible
  dynamic "admin_ssh_key" {
    for_each = concat(
      [for f in fileset("${path.module}/ssh-keys", "*.pub") : file("${path.module}/ssh-keys/${f}")],
      [tls_private_key.mgmt.public_key_openssh],
    )
    content {
      username   = var.admin_username
      public_key = admin_ssh_key.value
    }
  }

  # System-assigned identity only for VMs that need passwordless access to Azure services
  dynamic "identity" {
    for_each = each.value.managed_identity ? [1] : []
    content {
      type = "SystemAssigned"
    }
  }

  os_disk {
    name                 = "osdisk-${each.key}"
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
