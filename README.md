# ZKOO Proof of Concept: Azure Infrastructure

Terraform code for the proof of concept (PoC) of the ZKOO data protection case. It deploys a segmented Azure environment that replaces the original "allow everything" setup with least-privilege network rules, two controlled entry points and private access to sensitive data.

The design follows the SOLL architecture (SOLL-7.0). Configuration of the virtual machines themselves (OpenVPN, nginx with ModSecurity, Suricata, Samba, SFTP) is handled separately with Ansible.

## Architecture overview

| Subnet | Address range | Purpose |
|---|---|---|
| snet-edge | 192.168.1.0/24 | Entry points: reverse proxy with WAF, OpenVPN server |
| snet-frontend | 192.168.4.0/22 | Services for external users: patient portal, website, media, SFTP |
| snet-backend | 192.168.8.0/22 | Internal services for employees: business application, file server |
| snet-mgmt | 192.168.13.0/28 | Management jump host and IDS |
| snet-pep | 192.168.14.0/27 | Private endpoints to Azure SQL, Azure Files and App Service |

All subnets share the virtual network `vnet-zkoo-01` (192.168.0.0/16). VPN users receive an address from one of two pools that live outside the VNet:

| Pool | Address range | Users |
|---|---|---|
| employee-pool | 10.8.0.0/22 | ZKOO employees |
| admin-pool | 10.8.4.0/24 | Administrators (MFA required) |

Only `vm-proxy-01` and `vm-vpn-01` have a public IP address. Every other resource is reachable only through those two VMs.

## Prerequisites

- Terraform 1.x
- Azure CLI, logged in with `az login`
- Contributor access to the resource group `2026_KE06_KDB1_casusgroep_04`
- An SSH key pair (RSA, 4096 bits). Create one with `ssh-keygen -t rsa -b 4096` if needed

## Usage

```bash
terraform init      # download the azurerm provider
terraform fmt       # format the code
terraform plan      # preview the changes
terraform apply     # create the resources
terraform destroy   # remove everything
```

Run `terraform destroy` when the environment is not in use for a longer period to avoid unnecessary costs.

## Variables

| Variable | Default | Description |
|---|---|---|
| `subscription_id` | Data Protection subscription | Azure subscription to deploy into |
| `resource_group_name` | `2026_KE06_KDB1_casusgroep_04` | Existing resource group provided by the school |
| `admin_username` | `azureadmin` | Local admin account on all Linux VMs |
| `ssh_public_key_path` | `~/.ssh/id_rsa.pub` | Path to the SSH public key for the admin account |

Override a default without changing the code, for example:

```bash
terraform plan -var="ssh_public_key_path=~/.ssh/my_key.pub"
```

## File structure

### Current files

| File | Contents |
|---|---|
| `terraform.tf` | Required Terraform providers and version constraints |
| `providers.tf` | Configuration of the azurerm provider |
| `variables.tf` | Input variables that can differ per environment or user |
| `main.tf` | Data source for the existing resource group |
| `locals.tf` | Shared values: VPN pools, private endpoint addresses and the map of all VMs with their subnet, IP address, size and ASG |
| `network.tf` | Virtual network, subnets, public IP addresses, route table for the VPN pools and its subnet associations |
| `security.tf` | Application security groups, network security groups with their rules, and NSG subnet associations |
| `compute.tf` | Network interfaces, ASG associations and the ten Linux VMs |
| `outputs.tf` | Public IP addresses of the proxy and VPN server, and private IP addresses of all VMs for the Ansible inventory |

### Planned files

| File | Planned contents |
|---|---|
| `database.tf` | Azure SQL server `sql-zkoo-01` and database `sqldb-zkoo-01`, with public access disabled and Entra ID authentication only |
| `storage.tf` | Storage account `stzkoosensitive01` with an Azure Files share for sensitive medical files, public access disabled, soft delete enabled |
| `appservice.tf` | App Service plan, `app-zkoo-02` (private, reachable only through its private endpoint) and `app-zkoo-03` (public endpoint, restricted to the proxy's public IP) |
| `private_endpoints.tf` | Private endpoints `pep-sql`, `pep-sensitivedata` and `pep-webapp` with fixed addresses, private DNS zones and their VNet links |
| `identity.tf` | Managed identity for `vm-web-01` and role assignments for access to Azure SQL and the file share |
| `monitoring.tf` | Log Analytics workspace, diagnostic settings for Azure SQL and storage, and automatic shutdown schedules for the VMs |

## Naming convention

Resources follow the Microsoft Cloud Adoption Framework: `<type>-<role>-<number>`, in lowercase. Examples: `vm-web-01`, `nsg-edge`, `pep-sql`. Storage accounts do not allow hyphens, so their name is written as one word: `stzkoosensitive01`.

Inside the code, Terraform resource names use underscores (`snet_edge`), while the Azure names use hyphens (`snet-edge`).

## Security notes

- **Never commit state files.** `terraform.tfstate` can contain secrets in plain text. The `.gitignore` excludes it.
- **Never commit private SSH keys.** Only the public key (`.pub`) is referenced in the code.
- **Commit `.terraform.lock.hcl`.** It makes sure everyone uses the same provider version.
- **Least privilege.** Every NSG ends with an explicit deny rule. Rules use a specific VM (through an ASG) or address range as source and destination.
- **Placeholder partner range.** The SFTP rule in `nsg-edge` uses the documentation range `203.0.113.0/24` until real partner IP ranges are known.