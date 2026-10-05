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

variable "ssh_public_key_path" {
  description = "Path to the SSH public key used for the admin account"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
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