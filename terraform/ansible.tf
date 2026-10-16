locals {
  ansible_groups = distinct([for k, v in local.vms : v.ansible_group])

  ansible_hosts = {
    for k, v in local.vms : "vm-${k}" => {
      group   = v.ansible_group
      address = v.ip
      # Ansible runs on the jump host itself, so it configures itself locally
      local = k == "mgmt-01"
      # Extra SSH sources for ufw; empty means the playbook default (jump host only)
      ssh_sources = k == "mgmt-01" ? [local.admin_pool] : []
      # Host-specific variables; the VPN server needs its public IP for the client profiles
      extra_vars = k == "vpn-01" ? { vpn_public_ip = azurerm_public_ip.pip_vpn.ip_address } : {}
    }
  }

  # Rendered once and used both for the local file and for the bootstrap of vm-mgmt-01
  ansible_inventory = templatefile("${path.module}/inventory.tftpl", {
    groups         = local.ansible_groups
    hosts          = local.ansible_hosts
    admin_username = var.admin_username
    key_vault_name = local.key_vault_name
  })
}

# Writes the Ansible inventory so IPs never have to be copied by hand
resource "local_file" "ansible_inventory" {
  filename        = "${path.module}/../ansible/inventory.ini"
  file_permission = "0644"
  content         = local.ansible_inventory
}
