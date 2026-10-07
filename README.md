# ZKOO Proof of Concept: Azure Infrastructure

Terraform code for the proof of concept (PoC) of the ZKOO data protection case. It deploys a segmented Azure environment that replaces the original "allow everything" setup with least-privilege network rules, two controlled entry points and private access to sensitive data.

The design follows the SOLL architecture (SOLL-7.0). Configuration of the virtual machines themselves (OpenVPN, nginx with ModSecurity, Suricata, Samba, SFTP) is handled separately with Ansible.

## Architecture overview

### Network

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

Only `vm-proxy-01` and `vm-vpn-01` have a public IP address. Every other VM is reachable only through those two VMs.

### Services outside the VNet

| Service | Name | Access |
|---|---|---|
| Azure SQL server and database | `sql-zkoo-01` / `sqldb-zkoo-01` | Private endpoint `pep-sql` only, public access disabled, Entra ID authentication only |
| Storage account with Azure Files share | `stzkoosensitive01` | Private endpoint `pep-sensitivedata` only, public access disabled |
| Web app | `app-zkoo-02` | Private endpoint `pep-webapp` only, public access disabled |
| Web app | `app-zkoo-03` | Public endpoint, restricted to the public IP of `vm-proxy-01` |

## Prerequisites

- Terraform 1.x (latest version recommended for azurerm 5)
- azurerm provider `~> 5.5` (installed automatically by `terraform init`)
- Azure CLI, logged in with `az login` to the Data Protection subscription
- Contributor access to the resource group `2026_KE06_KDB1_casusgroep_04`
- An SSH key pair (RSA, 4096 bits). Create one with `ssh-keygen -t rsa -b 4096` if needed (works on macOS and in Windows PowerShell)
- Your public key added to `terraform/ssh-keys/` (see below)

## Usage

All Terraform files are in the `terraform` folder. Run every command from there:

```bash
cd terraform
terraform init      # download the azurerm provider
terraform fmt       # format the code
terraform plan      # preview the changes
terraform apply     # create the resources
terraform destroy   # remove everything
```

**After every `git pull`, run `terraform init` first.** The `.terraform` folder is not in Git, so everyone downloads the provider locally. Without it, your editor and Terraform may use an outdated provider version and show errors for valid code.

### Costs and automatic shutdown

All VMs shut down automatically every day at 19:00 (W. Europe Standard Time). They do not start again by themselves. Start all VMs at once with:

```bash
az vm start --ids $(az vm list -g 2026_KE06_KDB1_casusgroep_04 --query "[].id" -o tsv)
```

Run `terraform destroy` when the environment is not in use for a longer period to avoid unnecessary costs.

## Variables

| Variable | Default | Description |
|---|---|---|
| `subscription_id` | Data Protection subscription | Azure subscription to deploy into |
| `resource_group_name` | `2026_KE06_KDB1_casusgroep_04` | Existing resource group provided by the school |
| `admin_username` | `azureadmin` | Local admin account on all Linux VMs |
| `sql_admin_login` | Group member's school email | Email address of the Microsoft Entra user that administers the SQL server |
| `sql_admin_object_id` | Object ID of that user | Object ID of the Microsoft Entra user that administers the SQL server |

Override a default without changing the code, for example:

```bash
terraform plan -var="admin_username=myadmin"
```

## File structure

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
| `database.tf` | Azure SQL server `sql-zkoo-01` and database `sqldb-zkoo-01`, with public access disabled and Entra ID authentication only |
| `storage.tf` | Storage account `stzkoosensitive01` with an Azure Files share for sensitive medical files, public access disabled, soft delete enabled |
| `appservice.tf` | App Service plan, `app-zkoo-02` (private, reachable only through its private endpoint) and `app-zkoo-03` (public endpoint, restricted to the proxy's public IP) |
| `private_endpoints.tf` | Private endpoints `pep-sql`, `pep-sensitivedata` and `pep-webapp` with fixed addresses, private DNS zones and their VNet links |
| `monitoring.tf` | Automatic daily shutdown of all VMs, Log Analytics workspace, SQL server auditing and file share access logs sent to Log Analytics |
| `outputs.tf` | Public IP addresses of the proxy and VPN server, and private IP addresses of all VMs for the Ansible inventory |

### Planned changes

- `compute.tf`: system-assigned managed identity on `vm-web-01`, used to access Azure SQL without a password in the application code.

## SSH access for the team

Every team member's **public** key is stored in `terraform/ssh-keys/` as `<firstname>.pub`. Terraform adds all of them to the `azureadmin` account on every VM, so everyone can log in with their own key, no matter who runs `terraform apply`.

- Never add a private key to this folder.
- Adding or removing a key recreates the VMs. Agree on the keys before the first `terraform apply`.

## Naming convention

Resources follow the Microsoft Cloud Adoption Framework: `<type>-<role>-<number>`, in lowercase. Examples: `vm-web-01`, `nsg-edge`, `pep-sql`. Storage accounts do not allow hyphens, so their name is written as one word: `stzkoosensitive01`.

Inside the code, Terraform resource names use underscores (`snet_edge`), while the Azure names use hyphens (`snet-edge`).

## Security notes

- **Never commit state files.** `terraform.tfstate` can contain secrets in plain text. The `.gitignore` excludes it.
- **Never commit private SSH keys.** Only the public key (`.pub`) is referenced in the code.
- **Commit `.terraform.lock.hcl`.** It makes sure everyone uses the same provider version.
- **Least privilege.** Every NSG ends with an explicit deny rule. Rules use a specific VM (through an ASG) or address range as source and destination.
- **Placeholder partner range.** The SFTP rule in `nsg-edge` uses the documentation range `203.0.113.0/24` until real partner IP ranges are known.
