# ZKOO Proof of Concept: Data Protection in the Cloud

*[Nederlandse versie](README.nl.md)*

Infrastructure as Code for the proof of concept (PoC) of the ZKOO data protection case. Terraform builds a segmented Azure environment; Ansible configures the virtual machines. The design follows the SOLL architecture (SOLL-7.0): least-privilege network rules, two controlled entry points (a WAF reverse proxy and a VPN) and private access to sensitive data.

**Ground rule:** after `terraform apply`, all management runs from the jump host `vm-mgmt-01` over the VPN. Nobody connects to the VMs directly from a laptop, and Ansible never runs from a laptop.

## Contents

- [Architecture](#architecture)
- [Repository layout](#repository-layout)
- [Prerequisites](#prerequisites)
- [Deploying the environment](#deploying-the-environment)
- [Connecting through the VPN](#connecting-through-the-vpn)
- [Configuring the VMs with Ansible](#configuring-the-vms-with-ansible)
- [Testing the routes](#testing-the-routes)
- [Common tasks](#common-tasks)
- [Security design](#security-design)
- [Known pitfalls](#known-pitfalls)
- [Tearing down](#tearing-down)
- [Team agreements](#team-agreements)

## Architecture

### Network

All subnets live in `vnet-zkoo-01` (192.168.0.0/16).

| Subnet | Address range | VMs | Purpose |
|---|---|---|---|
| snet-edge | 192.168.1.0/24 | vm-proxy-01 (.4), vm-vpn-01 (.5) | Only entry points from the internet |
| snet-frontend | 192.168.4.0/22 | vm-web-01 (.4), vm-web-02 (.5), vm-media-01 (.6), vm-ftp-01 (.7) | Services reached through the proxy |
| snet-backend | 192.168.8.0/22 | vm-app-01 (.4), vm-fs-01 (.5) | Internal services for employees |
| snet-mgmt | 192.168.13.0/28 | vm-mgmt-01 (.4), vm-ids-01 (.5) | Jump host and IDS |
| snet-pep | 192.168.14.0/27 | – | Private endpoints for SQL, Azure Files and App Service |

VPN clients get an address from one of two pools outside the VNet. The route table `rt-vpn` sends replies for these pools back to `vm-vpn-01`; there is no NAT, so every VM sees the real client address.

| Pool | Range | Users | Authentication |
|---|---|---|---|
| employee-pool | 10.8.0.0/22 | ZKOO employees | Certificate |
| admin-pool | 10.8.4.0/24 | Administrators, fixed address per admin | Certificate + TOTP (MFA) |

Only `vm-proxy-01` and `vm-vpn-01` have a public IP address.

### Services per VM

| VM | Service | Runs as |
|---|---|---|
| vm-proxy-01 | nginx + ModSecurity + OWASP CRS (WAF) on 443; TCP relay for partner SFTP on 2222 | Docker |
| vm-web-01 | Patient portal, reached at `/portaal/` through the WAF | Docker |
| vm-web-02 | Public company website, reached at `/` through the WAF | Docker |
| vm-app-01 | Business application for employees (HTTPS) | Docker |
| vm-fs-01 | Samba file share for employees (SMB3) | Docker |
| vm-ftp-01 | SFTP for partners, chrooted per partner | Native sshd |
| vm-vpn-01 | OpenVPN + dnsmasq DNS forwarder | Native |
| vm-mgmt-01 | Jump host and Ansible control node | Native |
| vm-ids-01 | Suricata IDS, fed by a software TAP from the proxy and the VPN server | Native |
| vm-media-01 | Media server on 8096 (planned) | Docker |

Services run in containers for isolation and reproducibility. The VPN, the jump host and the IDS stay native because they need host networking (tun device, routing, packet capture), so a container would add a layer without adding isolation. SFTP uses the host's own sshd, which already listens on port 22.

### Services outside the VNet

| Service | Name | Access |
|---|---|---|
| Azure SQL | `sql-zkoo-01` / `sqldb-zkoo-01` | Private endpoint `pep-sql` only, Entra ID authentication only |
| Azure Files | `stzkoosensitive01`, share `medical-files` | Private endpoint `pep-sensitivedata` only |
| App Service | `app-zkoo-02` | Private endpoint `pep-webapp` only |
| App Service | `app-zkoo-03` | Public endpoint, restricted to the proxy's public IP |
| Key Vault | `kv-zkoo-<random>` | Secrets for the bootstrap, VPN profiles and share passwords |
| Log Analytics | – | SQL auditing and file share access logs |

### Routes

| Route | Path |
|---|---|
| Users | Internet → WAF (443) → web-02 (`/`) or web-01 (`/portaal/`) |
| Partners | Partner IP → proxy (2222) → vm-ftp-01 (22), chrooted SFTP |
| Employees | OpenVPN → employee-pool → vm-app-01 (443), vm-fs-01 (445), Azure Files (445) |
| Admins | OpenVPN + TOTP → admin-pool → vm-mgmt-01 (22) → all VMs (22) |
| Attacker | Internet → only 443 and 1194 are open; SQLi/XSS is blocked by the WAF (403); scans and known attack patterns raise Suricata alerts |

### Intrusion detection

Azure has no switch with a mirror port, so a VM never sees traffic meant for another VM. The two entry points therefore act as a software TAP: on `vm-proxy-01` and `vm-vpn-01`, `tc` copies every packet on `eth0` (both directions) into a VXLAN tunnel (UDP 4789) to `vm-ids-01`. Suricata only runs there and listens on the tunnel interface `vxmirror`.

```
vm-proxy-01 ─┐  copy of every packet on eth0
             ├── VXLAN (UDP 4789) ──► vm-ids-01: Suricata on vxmirror
vm-vpn-01 ───┘
```

- Rules: Emerging Threats Open, updated weekly with `suricata-update`.
- Alerts: `/var/log/suricata/fast.log` (one line per alert) and `/var/log/suricata/eve.json` (full JSON).
- On the VPN server the copy includes the decrypted client traffic, because it leaves through `eth0` into the VNet.
- HTTPS stays encrypted for the IDS. The WAF covers the application layer; Suricata covers the network layer (scans, brute force, known exploit patterns, DNS).

## Repository layout

```
terraform/
  terraform.tf           providers and the remote state backend
  providers.tf           azurerm provider settings
  variables.tf           input variables
  locals.tf              pools, private endpoint IPs, map of all VMs, Key Vault name
  main.tf                existing resource group (data source)
  network.tf             VNet, subnets, public IPs, route table rt-vpn
  security.tf            ASGs and NSGs (every NSG ends with deny-all)
  compute.tf             NICs and the ten Linux VMs, cloud-init for vm-mgmt-01
  keyvault.tf            Key Vault, access policies and bootstrap secrets
  database.tf            Azure SQL
  storage.tf             storage account and Azure Files share
  appservice.tf          App Service plan and web apps
  private_endpoints.tf   private endpoints and private DNS zones
  monitoring.tf          Log Analytics, diagnostics, daily VM shutdown
  ansible.tf             generates ../ansible/inventory.ini
  inventory.tftpl        template for the Ansible inventory
  cloud-init/            bootstrap script for vm-mgmt-01
  ssh-keys/              team public keys (*.pub only)
ansible/
  playbook.yml           one play per VM group
  inventory.ini          generated by Terraform, do not edit by hand
  requirements.yml       Ansible collections
  group_vars/            settings per group (all.yml holds the VPN users)
  templates/             config files per service
  files/sftp-keys/       partner public keys (*.pub only)
```

## Prerequisites

- Terraform 1.x and the Azure CLI, logged in with `az login`
- Contributor access to the resource group `2026_KE06_KDB1_casusgroep_04`
- Your public SSH key in `terraform/ssh-keys/<firstname>.pub`
- The private GitHub deploy key at `~/.ssh/zkoo_deploy` (only on the machine that runs Terraform). Its public half is a read-only deploy key on the GitHub repository.
- OpenVPN Connect and an authenticator app (TOTP) for admins
- `qrencode` to show the TOTP QR code (`brew install qrencode`)

### Remote state

The Terraform state lives in Azure (see the backend in `terraform.tf`): storage account `stzkootfstate01`, container `tfstate`, key `zkoo.tfstate`. That account was created once with the Azure CLI and is not managed by Terraform, so `terraform destroy` never deletes it. Blob versioning and soft delete protect the state against mistakes.

## Deploying the environment

Run from the `terraform` folder on the Terraform machine (see [Team agreements](#team-agreements)):

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

The apply takes about 15 to 20 minutes. Then `vm-mgmt-01` bootstraps itself through cloud-init, with no laptop involved:

1. installs the Azure CLI and logs in with its **managed identity**;
2. reads the GitHub deploy key and its own SSH key from Key Vault;
3. clones this repository;
4. runs the Ansible plays for `vpn` and `mgmt`;
5. stores a VPN profile per user and a TOTP secret per admin in Key Vault.

Follow the bootstrap (about 10 minutes):

```bash
az vm run-command invoke -g 2026_KE06_KDB1_casusgroep_04 -n vm-mgmt-01 \
  --command-id RunShellScript --scripts "tail -5 /var/log/zkoo-bootstrap.log" \
  --query "value[0].message" -o tsv
```

Wait for `Bootstrap finished`. Then commit the regenerated `ansible/inventory.ini`.

## Connecting through the VPN

Download your profile and TOTP secret from the new Key Vault (from the `terraform` folder):

```bash
KV=$(terraform output -raw key_vault_name)
az keyvault secret download --vault-name $KV --name vpn-profile-<user> --file ~/<user>.ovpn --overwrite
az keyvault secret show --vault-name $KV --name vpn-totp-<user> --query value -o tsv | qrencode -t ansiutf8
```

1. Import the `.ovpn` file in OpenVPN Connect. Remove the profile of a previous deployment first: every rebuild creates a new CA.
2. Scan the QR code with your authenticator app (admins only).
3. Connect with your user name. Admins enter the 6-digit TOTP code as password; employees leave it empty.
4. Log in on the jump host. Every rebuild gives it a new host key, so remove the old one first:

```bash
ssh-keygen -R 192.168.13.4
ssh azureadmin@192.168.13.4
```

Reboot `vm-mgmt-01` once after the first deployment so it loads the kernel updates from the bootstrap (`sudo reboot`).

## Configuring the VMs with Ansible

Always on `vm-mgmt-01`:

```bash
cd ~/data-protection && git pull
cd ansible
ansible-galaxy collection install -r requirements.yml
ansible-playbook -i /var/lib/zkoo/inventory.ini playbook.yml --limit proxy,webservers,sftp,appserver,fileserver,ids,vpn
```

The bootstrap already configured `vpn` and `mgmt`; including `vpn` again is harmless and adds the traffic mirror if it is missing. Use `/var/lib/zkoo/inventory.ini`: the bootstrap writes its own copy there, so `git pull` never conflicts with it. Add `--check` for a dry run.

## Testing the routes

From a laptop (users and attackers):

```bash
P=$(terraform output -raw proxy_public_ip)
curl -sk https://$P/ | grep Served                       # vm-web-02
curl -sk https://$P/portaal/ | grep Served               # vm-web-01
curl -sk -o /dev/null -w "%{http_code}\n" "https://$P/portaal/?id=1'%20OR%20'1'='1"   # 403 from the WAF
```

On `vm-mgmt-01` with a partner key (partners):

```bash
sftp -i <partner-key> partner01@192.168.4.7    # only "upload" is visible, cd /etc fails
ssh  -i <partner-key> partner01@192.168.4.7    # refused: "This service allows sftp connections only"
```

Connected as an employee (employees):

- `https://192.168.8.4` opens the business application
- Finder or Explorer: `smb://192.168.8.5/zkoo-data`, password from Key Vault (`smb-password-<user>`)
- `ssh azureadmin@192.168.13.4` must fail: employees cannot reach the jump host

On `vm-mgmt-01` (intrusion detection):

```bash
ssh 192.168.13.5 'sudo tcpdump -ni vxmirror -c 10'               # mirrored packets arrive
ssh 192.168.1.4 'curl -s http://testmynids.org/uid/index.html'   # standard Suricata test
ssh 192.168.13.5 'sudo tail -5 /var/log/suricata/fast.log'       # GPL ATTACK_RESPONSE id check returned root
```

A port scan from a laptop (`nmap -Pn <proxy-ip>`) should also show up in `fast.log`.

The full step-by-step test plan is in [docs/testplan.md](docs/testplan.md).

## Common tasks

| Task | How |
|---|---|
| Add a VPN admin or employee | Add the name to `vpn_admins` or `vpn_employees` in `ansible/group_vars/all.yml`, then rerun the `vpn` and `fileserver` plays. Employees automatically get a file share account. |
| Add an SFTP partner | Put the partner's public key in `ansible/files/sftp-keys/<name>.pub` and rerun the `sftp` play. Also add the partner's IP range to `partner_ip_ranges` (Terraform) and `proxy_sftp_allowed_from` (Ansible). |
| Add a team member's SSH key | Put `<firstname>.pub` in `terraform/ssh-keys/` before the next `terraform apply`. Changing keys recreates the VMs. |
| Look up a password or profile | `az keyvault secret list --vault-name $KV -o table` |
| Start the VMs after the daily shutdown | `az vm start --ids $(az vm list -g 2026_KE06_KDB1_casusgroep_04 --query "[].id" -o tsv)` |

## Security design

- **Two entry points.** Only 443 (WAF), 1194/udp (VPN) and 2222 (SFTP, partner IPs only) are open from the internet.
- **Least privilege per subnet.** Every NSG ends with an explicit deny-all; sources and destinations are specific VMs (ASGs) or VPN pools.
- **Defense in depth.** Every VM also runs `ufw` with the same rules as its NSG. Docker publishes ports through the `FORWARD` chain and would bypass `ufw`, so a `DOCKER-USER` rule set sends new inbound connections to containers through `ufw route` rules.
- **MFA for admins.** Admins need a certificate and a TOTP code; employees cannot reach the jump host.
- **No secrets in Git.** Passwords, VPN profiles, TOTP secrets and SSH keys live in Key Vault. The jump host reads them with its managed identity.
- **WAF.** ModSecurity with the OWASP Core Rule Set blocks SQL injection and XSS before they reach the patient portal, which must be treated as vulnerable. The WAF container runs as an unprivileged user.
- **Private data paths.** SQL, Azure Files and App Service are only reachable through private endpoints; their public access is disabled.
- **Hardened SSH.** Key login only, no root login, at most 3 attempts. SFTP partners get no shell, no TTY and no forwarding.
- **File share.** SMB3 only, encryption required, no guest access, employee pool only.
- **Intrusion detection.** Suricata on `vm-ids-01` inspects a copy of all traffic through both entry points; only the proxy and the VPN server may send to its tunnel port (NSG and `ufw`).
- **Logging.** `auditd` on every VM; SQL auditing and file share logs go to Log Analytics.

## Known pitfalls

| Symptom | Cause and fix |
|---|---|
| VPN connects, but the VMs do not answer | Forwarded VPN traffic leaves `vm-vpn-01` with a 10.8.x.x source. `snet-edge` has no route for the pools, so that source is not part of the `VirtualNetwork` tag and the default `AllowVnetOutBound` rule does not match. `nsg-edge` therefore has an explicit outbound rule `allow-vpn-clients-to-vnet`. |
| Bootstrap fails with `Forbidden` on Key Vault | A Key Vault recovered from soft delete keeps its old access policies. The vault name therefore gets a random suffix on every deployment. |
| WAF container keeps restarting | The image runs unprivileged and cannot bind below 1024. Host 443 maps to container 8443, and the `ufw route` rule uses 8443 because `DOCKER-USER` sees the port after Docker's DNAT. |
| `terraform destroy` hangs on Log Analytics | Permanent delete of the workspace is disabled in `providers.tf`. |
| `inventory.ini` shows as deleted after a destroy | Terraform removes the file with the environment. Restore it with `git restore ansible/inventory.ini`; do not commit the deletion. |
| Suricata sees only small packets | A VXLAN copy is 50 bytes larger than the original, so full-size packets are fragmented on the way to the IDS. If fragments do not arrive, Suricata still sees handshakes, scans and DNS, but not large data packets. |
| `$KV` or `$P` is empty | `terraform output` only works from the `terraform` folder, and shell variables only exist in the window where you set them. |

## Tearing down

Disconnect the VPN first, then:

```bash
cd terraform
terraform destroy
git restore ../ansible/inventory.ini
```

The Key Vault goes into soft delete for 7 days; the next deployment uses a new name, so it does not get in the way. The state storage account is not affected.

## Team agreements

- **One machine runs Terraform** (Tom's laptop). Others may run `terraform init`, `fmt` and `validate`, but never `plan`, `apply` or `destroy`.
- **Pull before you work**, and rebase instead of merging: `git config pull.rebase true`.
- **`inventory.ini` comes from Terraform only.** Never edit it by hand. In a conflict, take the version from the latest `terraform apply`.
- **Commit messages describe the change**, for example `feat(proxy): route /portaal/ to web-01`.
- **Code, comments and this README are in English**; a Dutch version is in [README.nl.md](README.nl.md). Keep both up to date.
