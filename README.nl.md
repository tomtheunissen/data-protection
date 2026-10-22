# ZKOO Proof of Concept: Data Protection in de Cloud

*[English version](README.md)*

Infrastructure as Code voor de proof of concept (PoC) van de ZKOO-casus over dataprotectie. Terraform bouwt een gesegmenteerde Azure-omgeving; Ansible configureert de virtuele machines. Het ontwerp volgt de SOLL-architectuur (SOLL-7.0): netwerkregels volgens least privilege, twee gecontroleerde toegangspunten (een reverse proxy met WAF en een VPN) en privétoegang tot gevoelige data.

**Basisregel:** na `terraform apply` loopt al het beheer via de jump host `vm-mgmt-01` over de VPN. Niemand maakt rechtstreeks vanaf een laptop verbinding met de VM's, en Ansible draait nooit vanaf een laptop.

## Inhoud

- [Architectuur](#architectuur)
- [Opbouw van de repository](#opbouw-van-de-repository)
- [Benodigdheden](#benodigdheden)
- [De omgeving uitrollen](#de-omgeving-uitrollen)
- [Verbinden via de VPN](#verbinden-via-de-vpn)
- [De VM's configureren met Ansible](#de-vms-configureren-met-ansible)
- [De routes testen](#de-routes-testen)
- [Veelvoorkomende taken](#veelvoorkomende-taken)
- [Beveiligingsontwerp](#beveiligingsontwerp)
- [Bekende valkuilen](#bekende-valkuilen)
- [Afbreken](#afbreken)
- [Teamafspraken](#teamafspraken)

## Architectuur

### Netwerk

Alle subnetten zitten in `vnet-zkoo-01` (192.168.0.0/16).

| Subnet | Adresbereik | VM's | Doel |
|---|---|---|---|
| snet-edge | 192.168.1.0/24 | vm-proxy-01 (.4), vm-vpn-01 (.5) | De enige toegangspunten vanaf internet |
| snet-frontend | 192.168.4.0/22 | vm-web-01 (.4), vm-web-02 (.5), vm-media-01 (.6), vm-ftp-01 (.7) | Diensten die via de proxy bereikbaar zijn |
| snet-backend | 192.168.8.0/22 | vm-app-01 (.4), vm-fs-01 (.5) | Interne diensten voor medewerkers |
| snet-mgmt | 192.168.13.0/28 | vm-mgmt-01 (.4), vm-ids-01 (.5) | Jump host en IDS |
| snet-pep | 192.168.14.0/27 | – | Private endpoints voor SQL, Azure Files en App Service |

VPN-clients krijgen een adres uit een van twee pools buiten het VNet. De route table `rt-vpn` stuurt antwoorden voor deze pools terug naar `vm-vpn-01`. Er is geen NAT, dus elke VM ziet het echte adres van de client.

| Pool | Bereik | Gebruikers | Authenticatie |
|---|---|---|---|
| employee-pool | 10.8.0.0/22 | Medewerkers van ZKOO | Certificaat |
| admin-pool | 10.8.4.0/24 | Beheerders, vast adres per beheerder | Certificaat + TOTP (MFA) |

Alleen `vm-proxy-01` en `vm-vpn-01` hebben een publiek IP-adres.

### Diensten per VM

| VM | Dienst | Draait als |
|---|---|---|
| vm-proxy-01 | nginx + ModSecurity + OWASP CRS (WAF) op 443; TCP-relay voor SFTP van partners op 2222 | Docker |
| vm-web-01 | Patiëntportaal, bereikbaar op `/portaal/` via de WAF; mount de Azure Files-share `medical-files` op `/mnt/medical-files` | Docker |
| vm-web-02 | Publieke bedrijfswebsite, bereikbaar op `/` via de WAF | Docker |
| vm-app-01 | Bedrijfsapplicatie voor medewerkers (HTTPS) | Docker |
| vm-fs-01 | Samba-fileshare voor medewerkers (SMB3) | Docker |
| vm-ftp-01 | SFTP voor partners, met een chroot per partner | Native sshd |
| vm-vpn-01 | OpenVPN + dnsmasq als DNS-forwarder | Native |
| vm-mgmt-01 | Jump host en Ansible-controller | Native |
| vm-ids-01 | Suricata IDS, gevoed door een software-TAP vanaf de proxy en de VPN-server | Native |
| vm-media-01 | Mediaserver op 8096 (gepland) | Docker |

Diensten draaien in containers voor isolatie en reproduceerbaarheid. De VPN, de jump host en de IDS blijven native, omdat ze host-netwerkrechten nodig hebben (tun-device, routering, packet capture). Een container zou daar alleen een extra laag toevoegen zonder extra isolatie. SFTP gebruikt de sshd van de host zelf, die al op poort 22 luistert.

### Diensten buiten het VNet

| Dienst | Naam | Toegang |
|---|---|---|
| Azure SQL | `sql-zkoo-01` / `sqldb-zkoo-01` | Alleen via private endpoint `pep-sql`, alleen Entra ID-authenticatie |
| Azure Files | `stzkoosensitive01`, share `medical-files` | Alleen via private endpoint `pep-sensitivedata` |
| App Service | `app-zkoo-02` | Alleen via private endpoint `pep-webapp` |
| App Service | `app-zkoo-03` | Publiek endpoint, beperkt tot het publieke IP van de proxy |
| Key Vault | `kv-zkoo-<willekeurig>` | Geheimen voor de bootstrap, VPN-profielen en share-wachtwoorden |
| Log Analytics | – | SQL-auditing en toegangslogs van de fileshare |

### Routes

| Route | Pad |
|---|---|
| Users | Internet → WAF (443) → web-02 (`/`) of web-01 (`/portaal/`) |
| Partners | Partner-IP → proxy (2222) → vm-ftp-01 (22), SFTP met chroot |
| Employees | OpenVPN → employee-pool → vm-app-01 (443), vm-fs-01 (445), Azure Files (445) |
| Admins | OpenVPN + TOTP → admin-pool → vm-mgmt-01 (22) → alle VM's (22) |
| Hacker | Internet → alleen 443 en 1194 staan open; SQLi en XSS worden door de WAF geblokkeerd (403); scans en bekende aanvalspatronen geven Suricata-meldingen |

### Intrusion detection

Azure heeft geen switch met een mirrorpoort, dus een VM ziet nooit verkeer dat voor een andere VM bedoeld is. De twee toegangspunten werken daarom als software-TAP: op `vm-proxy-01` en `vm-vpn-01` kopieert `tc` elk pakket op `eth0` (in beide richtingen) naar een VXLAN-tunnel (UDP 4789) naar `vm-ids-01`. Suricata draait alleen daar en luistert op de tunnelinterface `vxmirror`.

```
vm-proxy-01 ─┐  kopie van elk pakket op eth0
             ├── VXLAN (UDP 4789) ──► vm-ids-01: Suricata op vxmirror
vm-vpn-01 ───┘
```

- Regels: Emerging Threats Open, elke week bijgewerkt met `suricata-update`.
- Meldingen: `/var/log/suricata/fast.log` (één regel per melding) en `/var/log/suricata/eve.json` (volledige JSON).
- Op de VPN-server bevat de kopie ook het ontsleutelde verkeer van clients, omdat dat via `eth0` het VNet in gaat.
- HTTPS blijft voor de IDS versleuteld. De WAF dekt de applicatielaag af; Suricata het netwerk (scans, brute-force, bekende exploitpatronen, DNS).

## Opbouw van de repository

```
terraform/
  terraform.tf           providers en de backend voor de remote state
  providers.tf           instellingen van de azurerm-provider
  variables.tf           invoervariabelen
  locals.tf              pools, IP's van private endpoints, overzicht van alle VM's, Key Vault-naam
  main.tf                bestaande resourcegroep (data source)
  network.tf             VNet, subnetten, publieke IP's, route table rt-vpn
  security.tf            ASG's en NSG's (elke NSG eindigt met deny-all)
  compute.tf             NIC's en de tien Linux-VM's, cloud-init voor vm-mgmt-01
  keyvault.tf            Key Vault, access policies en geheimen voor de bootstrap
  database.tf            Azure SQL
  storage.tf             storage account en Azure Files-share
  appservice.tf          App Service-plan en webapps
  private_endpoints.tf   private endpoints en private DNS-zones
  monitoring.tf          Log Analytics, diagnostiek, dagelijkse uitschakeling van de VM's
  ansible.tf             genereert ../ansible/inventory.ini
  inventory.tftpl        template voor de Ansible-inventory
  cloud-init/            bootstrapscript voor vm-mgmt-01
  ssh-keys/              publieke sleutels van het team (alleen *.pub)
ansible/
  playbook.yml           één play per VM-groep
  inventory.ini          gemaakt door Terraform, niet met de hand aanpassen
  requirements.yml       Ansible-collections
  group_vars/            instellingen per groep (all.yml bevat de VPN-gebruikers)
  templates/             configbestanden per dienst
  files/sftp-keys/       publieke sleutels van partners (alleen *.pub)
```

## Benodigdheden

- Terraform 1.x en de Azure CLI, ingelogd met `az login`
- Contributor-rechten op de resourcegroep `2026_KE06_KDB1_casusgroep_04`
- Je publieke SSH-sleutel in `terraform/ssh-keys/<voornaam>.pub`
- De private GitHub-deploy key op `~/.ssh/zkoo_deploy` (alleen op de machine die Terraform draait). Het publieke deel staat als read-only deploy key op de GitHub-repository.
- OpenVPN Connect en een authenticator-app (TOTP) voor beheerders
- `qrencode` om de TOTP-QR-code te tonen (`brew install qrencode`)

### Remote state

De Terraform-state staat in Azure (zie de backend in `terraform.tf`): storage account `stzkootfstate01`, container `tfstate`, key `zkoo.tfstate`. Dat account is één keer met de Azure CLI aangemaakt en wordt niet door Terraform beheerd, dus `terraform destroy` verwijdert het nooit. Blob-versiebeheer en soft delete beschermen de state tegen vergissingen.

## De omgeving uitrollen

Draai dit vanuit de map `terraform` op de Terraform-machine (zie [Teamafspraken](#teamafspraken)):

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

De apply duurt ongeveer 15 tot 20 minuten. Daarna richt `vm-mgmt-01` zichzelf in via cloud-init, zonder dat er een laptop aan te pas komt:

1. installeert de Azure CLI en logt in met zijn **managed identity**;
2. haalt de GitHub-deploy key en zijn eigen SSH-sleutel uit de Key Vault;
3. kloont deze repository;
4. draait de Ansible-plays voor `vpn` en `mgmt`;
5. zet per gebruiker een VPN-profiel en per beheerder een TOTP-geheim in de Key Vault.

Volg de bootstrap (ongeveer 10 minuten):

```bash
az vm run-command invoke -g 2026_KE06_KDB1_casusgroep_04 -n vm-mgmt-01 \
  --command-id RunShellScript --scripts "tail -5 /var/log/zkoo-bootstrap.log" \
  --query "value[0].message" -o tsv
```

Wacht tot je `Bootstrap finished` ziet. Commit daarna de opnieuw gegenereerde `ansible/inventory.ini`.

## Verbinden via de VPN

Haal je profiel en TOTP-geheim op uit de nieuwe Key Vault (vanuit de map `terraform`):

```bash
KV=$(terraform output -raw key_vault_name)
az keyvault secret download --vault-name $KV --name vpn-profile-<gebruiker> --file ~/<gebruiker>.ovpn --overwrite
az keyvault secret show --vault-name $KV --name vpn-totp-<gebruiker> --query value -o tsv | qrencode -t ansiutf8
```

1. Importeer het `.ovpn`-bestand in OpenVPN Connect. Verwijder eerst het profiel van een eerdere uitrol: bij elke rebuild komt er een nieuwe CA.
2. Scan de QR-code met je authenticator-app (alleen beheerders).
3. Verbind met je gebruikersnaam. Beheerders vullen de TOTP-code van 6 cijfers in als wachtwoord; medewerkers laten het leeg.
4. Log in op de jump host. Na elke rebuild heeft die een nieuwe host key, dus verwijder eerst de oude:

```bash
ssh-keygen -R 192.168.13.4
ssh azureadmin@192.168.13.4
```

Reboot `vm-mgmt-01` na de eerste uitrol één keer, zodat de kernel-updates van de bootstrap geladen worden (`sudo reboot`).

## De VM's configureren met Ansible

Altijd op `vm-mgmt-01`:

```bash
cd ~/data-protection && git pull
cd ansible
ansible-galaxy collection install -r requirements.yml
ansible-playbook -i /var/lib/zkoo/inventory.ini playbook.yml --limit proxy,webservers,sftp,appserver,fileserver,ids,vpn
```

De bootstrap heeft `vpn` en `mgmt` al ingericht. `vpn` nog eens meenemen kan geen kwaad en zet de traffic mirror neer als die ontbreekt. Gebruik `/var/lib/zkoo/inventory.ini`: de bootstrap zet daar een eigen kopie neer, zodat `git pull` er nooit mee in conflict komt. Voeg `--check` toe voor een droge run.

## De routes testen

Vanaf een laptop (gebruikers en aanvallers):

```bash
P=$(terraform output -raw proxy_public_ip)
curl -sk https://$P/ | grep Served                       # vm-web-02
curl -sk https://$P/portaal/ | grep Served               # vm-web-01
curl -sk -o /dev/null -w "%{http_code}\n" "https://$P/portaal/?id=1'%20OR%20'1'='1"   # 403 van de WAF
```

Op `vm-mgmt-01` met een partnersleutel (partners):

```bash
sftp -i <partnersleutel> partner01@192.168.4.7    # alleen "upload" zichtbaar, cd /etc mislukt
ssh  -i <partnersleutel> partner01@192.168.4.7    # geweigerd: "This service allows sftp connections only"
```

Verbonden als medewerker (medewerkers):

- `https://192.168.8.4` opent de bedrijfsapplicatie
- Finder of Verkenner: `smb://192.168.8.5/zkoo-data`, met het wachtwoord uit de Key Vault (`smb-password-<gebruiker>`)
- `ssh azureadmin@192.168.13.4` moet mislukken: medewerkers kunnen niet bij de jump host

Op `vm-mgmt-01` (intrusion detection):

```bash
ssh 192.168.13.5 'sudo tcpdump -ni vxmirror -c 10'               # gekopieerde pakketten komen aan
ssh 192.168.1.4 'curl -s http://testmynids.org/uid/index.html'   # standaardtest voor Suricata
ssh 192.168.13.5 'sudo tail -5 /var/log/suricata/fast.log'       # GPL ATTACK_RESPONSE id check returned root
```

Een poortscan vanaf een laptop (`nmap -Pn <proxy-ip>`) hoort ook in `fast.log` te verschijnen.

Het volledige testplan, stap voor stap, staat in [docs/testplan.md](docs/testplan.md).

## Veelvoorkomende taken

| Taak | Hoe |
|---|---|
| Een VPN-beheerder of -medewerker toevoegen | Zet de naam in `vpn_admins` of `vpn_employees` in `ansible/group_vars/all.yml` en draai de plays `vpn` en `fileserver` opnieuw. Medewerkers krijgen automatisch een account op de fileshare. |
| Een SFTP-partner toevoegen | Zet de publieke sleutel van de partner in `ansible/files/sftp-keys/<naam>.pub` en draai de play `sftp` opnieuw. Voeg ook het IP-bereik van de partner toe aan `partner_ip_ranges` (Terraform) en `proxy_sftp_allowed_from` (Ansible). |
| De SSH-sleutel van een teamlid toevoegen | Zet `<voornaam>.pub` in `terraform/ssh-keys/` vóór de volgende `terraform apply`. Een wijziging in de sleutels maakt de VM's opnieuw aan. |
| Een wachtwoord of profiel opzoeken | `az keyvault secret list --vault-name $KV -o table` |
| De VM's starten na de dagelijkse uitschakeling | `az vm start --ids $(az vm list -g 2026_KE06_KDB1_casusgroep_04 --query "[].id" -o tsv)` |

## Beveiligingsontwerp

- **Twee toegangspunten.** Vanaf internet staan alleen 443 (WAF), 1194/udp (VPN) en 2222 (SFTP, alleen partner-IP's) open.
- **Least privilege per subnet.** Elke NSG eindigt met een expliciete deny-all. Bronnen en bestemmingen zijn specifieke VM's (ASG's) of VPN-pools.
- **Defense in depth.** Elke VM draait ook `ufw` met dezelfde regels als zijn NSG. Docker publiceert poorten via de `FORWARD`-chain en zou `ufw` omzeilen. Daarom sturen `DOCKER-USER`-regels nieuwe inkomende verbindingen naar containers langs `ufw route`-regels.
- **MFA voor beheerders.** Beheerders hebben een certificaat én een TOTP-code nodig; medewerkers kunnen niet bij de jump host.
- **Geen geheimen in Git.** Wachtwoorden, VPN-profielen, TOTP-geheimen en SSH-sleutels staan in de Key Vault. De jump host leest ze met zijn managed identity.
- **WAF.** ModSecurity met de OWASP Core Rule Set blokkeert SQL-injectie en XSS voordat die het patiëntportaal bereiken. Het portaal moet als kwetsbaar worden beschouwd. De WAF-container draait als gebruiker zonder rootrechten.
- **Privé datapaden.** SQL, Azure Files en App Service zijn alleen via private endpoints bereikbaar; publieke toegang staat uit. Alleen het patiëntportaal mount de share met medische bestanden (SMB 3.1.1 met versleuteling); de storage key komt uit de Key Vault en is alleen leesbaar voor root.
- **Geharde SSH.** Alleen inloggen met sleutels, geen root-login, maximaal 3 pogingen. SFTP-partners krijgen geen shell, geen TTY en geen forwarding.
- **Fileshare.** Alleen SMB3, versleuteling verplicht, geen gasttoegang, alleen de employee-pool.
- **Intrusion detection.** Suricata op `vm-ids-01` inspecteert een kopie van al het verkeer door beide toegangspunten. Alleen de proxy en de VPN-server mogen naar de tunnelpoort sturen (NSG en `ufw`).
- **Logging.** `auditd` op elke VM; SQL-auditing en logs van de fileshare gaan naar Log Analytics.

## Bekende valkuilen

| Symptoom | Oorzaak en oplossing |
|---|---|
| De VPN maakt verbinding, maar de VM's reageren niet | Doorgestuurd VPN-verkeer verlaat `vm-vpn-01` met een bronadres 10.8.x.x. `snet-edge` heeft geen route voor de pools, dus dat bronadres hoort daar niet bij de `VirtualNetwork`-tag, en de standaardregel `AllowVnetOutBound` geldt niet. `nsg-edge` heeft daarom een expliciete uitgaande regel `allow-vpn-clients-to-vnet`. |
| De bootstrap faalt met `Forbidden` op de Key Vault | Een Key Vault die uit soft delete terugkomt, houdt zijn oude access policies. De naam van de vault krijgt daarom bij elke uitrol een willekeurige toevoeging. |
| De WAF-container blijft herstarten | De image draait zonder rootrechten en kan geen poort onder 1024 openen. Host 443 wordt doorgestuurd naar container 8443, en de `ufw route`-regel gebruikt 8443, omdat `DOCKER-USER` de poort pas na de DNAT van Docker ziet. |
| `terraform destroy` blijft hangen op Log Analytics | Het permanent verwijderen van de workspace staat uit in `providers.tf`. |
| `inventory.ini` staat als verwijderd na een destroy | Terraform verwijdert het bestand samen met de omgeving. Zet het terug met `git restore ansible/inventory.ini`; commit de verwijdering niet. |
| Suricata ziet alleen kleine pakketten | Een VXLAN-kopie is 50 bytes groter dan het origineel, dus volle pakketten worden onderweg naar de IDS gesplitst. Komen de fragmenten niet aan, dan ziet Suricata nog wel verbindingsopbouw, scans en DNS, maar geen grote datapakketten. |
| `$KV` of `$P` is leeg | `terraform output` werkt alleen vanuit de map `terraform`, en shellvariabelen bestaan alleen in het venster waarin je ze hebt gezet. |

## Afbreken

Verbreek eerst de VPN-verbinding. Daarna:

```bash
cd terraform
terraform destroy
git restore ../ansible/inventory.ini
```

De Key Vault gaat 7 dagen in soft delete. De volgende uitrol gebruikt een nieuwe naam, dus hij zit niet in de weg. Het storage account met de state blijft staan.

## Teamafspraken

- **Eén machine draait Terraform** (de laptop van Tom). Anderen mogen `terraform init`, `fmt` en `validate` draaien, maar nooit `plan`, `apply` of `destroy`.
- **Eerst pullen, dan werken**, en rebasen in plaats van mergen: `git config pull.rebase true`.
- **`inventory.ini` komt alleen uit Terraform.** Pas het nooit met de hand aan. Bij een conflict neem je de versie van de laatste `terraform apply`.
- **Commitberichten beschrijven de wijziging**, bijvoorbeeld `feat(proxy): route /portaal/ to web-01`.
- **Code, commentaar en de hoofd-README zijn in het Engels**; deze Nederlandse versie hoort erbij. Houd ze allebei bij.
