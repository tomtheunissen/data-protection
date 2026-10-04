output "proxy_public_ip" {
  description = "Public IP address of vm-proxy-01 (WAF and reverse proxy)"
  value       = azurerm_public_ip.pip_proxy.ip_address
}

output "vpn_public_ip" {
  description = "Public IP address of vm-vpn-01 (OpenVPN)"
  value       = azurerm_public_ip.pip_vpn.ip_address
}

output "vm_private_ips" {
  description = "Private IP address of each VM, used for the Ansible inventory"
  value       = { for k, v in local.vms : "vm-${k}" => v.ip }
}
