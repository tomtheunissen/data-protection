variable "subscription_id" {
  description = "Azure subscription to deploy into"
  type        = string
  default     = "91760767-8ba3-4fab-9b01-fe9df3819f4b"
}

variable "resource_group_name" {
  description = "Existing resource group provided by the school"
  type        = string
  default     = "2026_KE06_KDB1_casusgroep_04"
}

variable "admin_username" {
  description = "Local admin account on all Linux VMs"
  type        = string
  default     = "azureadmin"
}

variable "sql_admin_login" {
  description = "Email address of the Microsoft Entra user that administers the SQL server"
  type        = string
  default     = "2503297theunissen@zuyd.nl"
}

variable "sql_admin_object_id" {
  description = "Object ID of the Microsoft Entra user that administers the SQL server"
  type        = string
  default     = "d0874a5b-50f8-4259-a0c0-07db7f3927a3"
}

variable "partner_ip_ranges" {
  description = "Public IP ranges of external partners allowed to use SFTP. Placeholder (TEST-NET-3) until the real partner ranges are known."
  type        = list(string)
  default     = ["203.0.113.0/24"]
}

variable "bootstrap_ssh_ips" {
  description = "Temporary public IPs (CIDR) allowed to SSH to vm-vpn-01 before the VPN is configured. Leave empty after bootstrap."
  type        = list(string)
  default     = []
}