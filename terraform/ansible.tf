locals {
  # During bootstrap vm-vpn-01 is reached on its public IP; afterwards through the jump host like every other VM
  bootstrap_mode = length(var.bootstrap_ssh_ips) > 0
  jumphost_ip    = local.vms["mgmt-01"].ip

  ansible_groups = distinct([for k, v in local.vms : v.ansible_group])

  ansible_hosts = {
    for k, v in local.vms : "vm-${k}" => {
      group   = v.ansible_group
      address = k == "vpn-01" && local.bootstrap_mode ? azurerm_public_ip.pip_vpn.ip_address : v.ip
      # Extra SSH sources for ufw; empty means the playbook default (jump host only)
      ssh_sources = (
        k == "vpn-01" && local.bootstrap_mode ? concat(var.bootstrap_ssh_ips, [local.jumphost_ip]) :
        k == "mgmt-01" ? [local.admin_pool] : []
      )
    }
  }

  # mgmt is reached directly over the VPN; vpn only goes through the jump host after bootstrap
  ansible_jumphost_groups = [
    for g in local.ansible_groups : g
    if g != "mgmt" && !(g == "vpn" && local.bootstrap_mode)
  ]
}

# Writes the Ansible inventory so IPs never have to be copied by hand
resource "local_file" "ansible_inventory" {
  filename        = "${path.module}/../ansible/inventory.ini"
  file_permission = "0644"
  content = templatefile("${path.module}/inventory.tftpl", {
    groups          = local.ansible_groups
    hosts           = local.ansible_hosts
    jumphost_groups = local.ansible_jumphost_groups
    jumphost_ip     = local.jumphost_ip
    admin_username  = var.admin_username
  })
}
