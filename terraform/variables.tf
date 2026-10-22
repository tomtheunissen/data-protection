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
  default     = ["203.0.113.0/24", "84.84.226.81/32"]
}

variable "team_object_ids" {
  description = "Entra object IDs of all team members who may read secrets from the Key Vault"
  type        = list(string)
  default = [
    "d0874a5b-50f8-4259-a0c0-07db7f3927a3", # Tom
    "3e435e69-145f-49a6-b26e-cb81852782ce", # Maddox
  ]
}

variable "deploy_key_path" {
  description = "Path to the private GitHub deploy key (read-only) that vm-mgmt-01 uses to clone the repo. Kept outside the repo."
  type        = string
  default     = "~/.ssh/zkoo_deploy"
}

variable "repo_url" {
  description = "SSH clone URL of this repository, used by vm-mgmt-01 with the read-only deploy key"
  type        = string
  default     = "git@github.com:tomtheunissen/data-protection.git"
}