# Testplan ZKOO PoC

Dit testplan controleert na een volledige uitrol of elke route uit de SOLL doet wat hij moet doen, ook de dingen die **niet** mogen. Vink elke test af en bewaar de output als bewijs voor het verslag, bijvoorbeeld met `| tee bewijs/<test-id>.txt` of een screenshot.

**Datum:** ____________ **Uitgevoerd door:** ____________

Gebruikte variabelen (in de map `terraform`):

```bash
KV=$(terraform output -raw key_vault_name)
P=$(terraform output -raw proxy_public_ip)
V=$(terraform output -raw vpn_public_ip)
```

---

## 0. Voorbereiding (vóór `terraform apply`)

| ID | Stap | Verwacht | ✓ |
|---|---|---|---|
| T0.1 | Optioneel, voor test P4: zet je eigen publieke IP (`curl -4 ifconfig.me`) tijdelijk als `/32` in `partner_ip_ranges` (Terraform) én `proxy_sftp_allowed_from` (Ansible). Commit en push. | Beide lijsten bevatten je IP | ☐ |
| T0.2 | `git status` op je laptop | `working tree clean`, alles gepusht | ☐ |

## 1. Uitrol

| ID | Stap | Verwacht | ✓ |
|---|---|---|---|
| T1.1 | `terraform apply` | `Apply complete!`, 0 errors | ✓ |
| T1.2 | Bootstrap volgen met `tail -5 /var/log/zkoo-bootstrap.log` (Run Command) | `failed=0` voor vm-mgmt-01 en vm-vpn-01, daarna `Bootstrap finished` | ✓ |
| T1.3 | VPN-profielen en TOTP ophalen uit `$KV` (tom en medewerker01) | `.ovpn`-bestanden gedownload, QR-code gescand | ✓ |
| T1.4 | Verbinden als tom, `ssh-keygen -R 192.168.13.4`, inloggen op mgmt, `sudo reboot` | Ingelogd; na de reboot opnieuw ingelogd | ✓ |
| T1.5 | Op mgmt: `git pull`, collections installeren, playbook met `--limit proxy,webservers,sftp,appserver,fileserver,ids,vpn` | `failed=0` en `unreachable=0` voor elke VM | ✓ |
| T1.6 | Nieuwe `ansible/inventory.ini` committen (laptop) | Gepusht | ✓ |

## 2. Route Admin (VPN + MFA → jump host)

Verbonden als **tom**.

| ID | Test | Commando | Verwacht | ✓ |
|---|---|---|---|---|
| A1 | VPN met geldige TOTP | Verbinden in OpenVPN Connect | *Securely Connected*, adres 10.8.4.10 (`ifconfig \| grep 10.8.4`) | ✓ |
| A2 | VPN met **foute** TOTP | Verbinden met code `000000` | Verbinding geweigerd (`AUTH_FAILED`) | ✓ |
| A3 | SSH naar de jump host | `ssh azureadmin@192.168.13.4` | Ingelogd | ✓ |
| A4 | Vanaf mgmt naar een andere VM | `ssh 192.168.1.5 hostname` | `vm-vpn-01` | ✓ |
| A5 | Admin kan **niet** bij de appserver | `curl -sk --max-time 5 https://192.168.8.4` (laptop) | Timeout | ✓ |
| A6 | Admin kan **niet** bij de fileserver | `nc -vz -G 5 192.168.8.5 445` (laptop) | Timeout | ✓ |
| A7 | Admin kan **niet** rechtstreeks bij een andere VM | `nc -vz -G 5 192.168.4.4 22` (laptop) | Timeout | ✓ |
| A8 | Private DNS via de VPN | `nslookup stzkoosensitive01.file.core.windows.net` (laptop) | Server 10.8.0.1, adres 192.168.14.4 | ✓ |

## 3. Route Users (internet → WAF → web)

Vanaf je laptop, VPN **uit**.

| ID | Test | Commando | Verwacht | ✓ |
|---|---|---|---|---|
| U1 | Bedrijfswebsite | `curl -sk https://$P/ \| grep Served` | `vm-web-02` | ✓ |
| U2 | Patiëntportaal | `curl -sk https://$P/portaal/ \| grep Served` | `vm-web-01` | ✓ |
| U3 | Doorverwijzing zonder slash | `curl -sk -o /dev/null -w "%{http_code} %{redirect_url}\n" https://$P/portaal` | `301` naar `/portaal/` | ✓ |
| U4 | HTTPS in de browser | `https://<proxy-ip>/` openen | Pagina laadt (na de certificaatwaarschuwing) | ☐ |

## 4. Route Hacker (internet)

Vanaf je laptop, VPN **uit**. Voor H5 en H6 heb je `nmap` nodig (`brew install nmap`).

| ID | Test | Commando | Verwacht | ✓ |
|---|---|---|---|---|
| H1 | SQL-injectie op het portaal | `curl -sk -o /dev/null -w "%{http_code}\n" "https://$P/portaal/?id=1'%20OR%20'1'='1"` | `403` | ✓ |
| H2 | XSS | `curl -sk -o /dev/null -w "%{http_code}\n" "https://$P/?q=<script>alert(1)</script>"` | `403` | ✓ |
| H3 | Path traversal | `curl -sk -o /dev/null -w "%{http_code}\n" "https://$P/portaal/?file=../../../../etc/passwd"` | `403` | ✓ |
| H4 | Scanner-user-agent | `curl -sk -o /dev/null -w "%{http_code}\n" -A "sqlmap/1.7" https://$P/` | `403` | ✓ |
| H5 | Open poorten op de proxy | `nmap -Pn -p 1-10000 $P` | Alleen `443/tcp` open (2222 alleen als je IP in T0.1 is toegevoegd) | ✓ |
| H6 | Open poorten op de VPN-server | `nmap -Pn -p 1-10000 $V` | Geen TCP-poorten open (OpenVPN is UDP) | ✓ |
| H7 | SSH op de publieke IP's | `nc -vz -G 5 $P 22` en `nc -vz -G 5 $V 22` | Allebei timeout | ✓ |
| H8 | Melding in de WAF-log | Op mgmt: `ssh 192.168.1.4 'sudo docker logs proxy-waf-1 --tail 200 2>&1 \| grep -ci modsecurity'` | Groter dan 0 (meldingen van H1 t/m H4) | ✓ |

## 5. Route Partners (SFTP)

| ID | Test | Commando | Verwacht | ✓ |
|---|---|---|---|---|
| P1 | Inloggen met sleutel (vanaf mgmt) | Testsleutel tijdelijk op mgmt, `sftp -i ~/.ssh/zkoo_partner01 partner01@192.168.4.7` | `Connected` | ✓ |
| P2 | Chroot | In sftp: `pwd`, `ls`, `cd /etc` | `/`, alleen `upload`, `cd /etc` mislukt | ✓ |
| P3 | Upload | `put /etc/hostname upload/test.txt`, `ls upload` | `test.txt` staat er | ✓ |
| P4 | Via de relay op de proxy (alleen met T0.1) | Laptop: `sftp -P 2222 -i ~/.ssh/zkoo_partner01 partner01@$P` | `Connected`, zelfde chroot | ✓ |
| P5 | Relay vanaf een niet-partner-IP | Zonder T0.1, of via de hotspot van je telefoon: `nc -vz -G 5 $P 2222` | Timeout | ✓ |
| P6 | Geen shell | `ssh -i ~/.ssh/zkoo_partner01 partner01@192.168.4.7` | `This service allows sftp connections only.` | ✓ |
| P7 | Opruimen | `rm ~/.ssh/zkoo_partner01` op mgmt | Testsleutel weg van mgmt | ✓ |

## 6. Route Employees (VPN → app en fileserver)

Verbonden als **medewerker01**. Laat het wachtwoord leeg; wil OpenVPN Connect dat niet, vul dan iets willekeurigs in. Medewerkers worden alleen op hun certificaat gecontroleerd.

| ID | Test | Commando | Verwacht | ✓ |
|---|---|---|---|---|
| E1 | VPN zonder TOTP | Verbinden | Verbonden, adres in 10.8.0.0/22 | ☐ |
| E2 | Appserver | `curl -sk https://192.168.8.4/` | Pagina van vm-app-01 | ☐ |
| E3 | Fileserver: verbinden | Wachtwoord: `az keyvault secret show --vault-name $KV --name smb-password-medewerker01 --query value -o tsv`. Finder → Ga → Verbind met server → `smb://192.168.8.5/zkoo-data` | Share geopend | ☐ |
| E4 | Fileserver: schrijven | Een bestand naar de share slepen | Bestand staat erop | ☐ |
| E5 | Fileserver: fout wachtwoord | Opnieuw verbinden met een fout wachtwoord | Geweigerd | ☐ |
| E6 | Medewerker kan **niet** bij de jump host | `nc -vz -G 5 192.168.13.4 22` | Timeout | ☐ |
| E7 | Medewerker kan **niet** bij het frontend | `nc -vz -G 5 192.168.4.4 443` | Timeout | ☐ |
| E8 | Bestand op de server | Als admin op mgmt: `ssh 192.168.8.5 'sudo ls -l /srv/samba/zkoo-data'` | Bestand van E4, groep `1500` | ☐ |

## 6b. Medische bestanden (Azure Files via private endpoint)

Verbonden als **tom**, op mgmt.

| ID | Test | Commando | Verwacht | ✓ |
|---|---|---|---|---|
| S1 | Share gemount op het portaal | `ssh 192.168.4.4 'findmnt /mnt/medical-files'` | Type `cifs`, opties met `vers=3.1.1` en `seal` | ✓ |
| S2 | Via het private endpoint | `ssh 192.168.4.4 'getent hosts stzkoosensitive01.file.core.windows.net'` | 192.168.14.4 | ✓ |
| S3 | Schrijven | `ssh 192.168.4.4 'sudo touch /mnt/medical-files/testbestand && sudo ls -l /mnt/medical-files'` | `testbestand` staat erop | ✓ |
| S4 | Sleutel alleen leesbaar voor root | `ssh 192.168.4.4 'sudo stat -c "%a %U" /etc/smbcredentials/stzkoosensitive01.cred'` | `600 root` | ✓ |
| S5 | Een andere VM kan **niet** bij de share | `ssh 192.168.4.5 'timeout 5 bash -c "</dev/tcp/192.168.14.4/445" && echo open \|\| echo geblokkeerd'` | `geblokkeerd` (nsg-pep) | ✓ |
| S6 | Geen publieke toegang | Laptop, VPN **uit**: `nc -vz -G 5 stzkoosensitive01.file.core.windows.net 445` | Mislukt (publieke toegang staat uit) | ☐ |

## 7. Intrusion detection

Verbonden als **tom**, op mgmt.

| ID | Test | Commando | Verwacht | ✓ |
|---|---|---|---|---|
| I1 | Services draaien | `ssh 192.168.13.5 'systemctl is-active zkoo-ids-tap suricata'` | 2× `active` | ✓ |
| I2 | Mirror draait op beide toegangspunten | `ssh 192.168.1.4 'systemctl is-active zkoo-mirror'` en hetzelfde voor `192.168.1.5` | `active` | ✓ |
| I3 | Kopieën komen aan | `ssh 192.168.13.5 'sudo tcpdump -ni vxmirror -c 20'` (terwijl je U1 draait) | Pakketten van en naar 192.168.1.4 | ✓ |
| I4 | Grote pakketten komen aan | `ssh 192.168.13.5 'sudo timeout 30 tcpdump -ni vxmirror -c 5 greater 1200'` (draai intussen `ssh 192.168.1.4 'curl -s -o /dev/null https://www.microsoft.com'`) | Pakketten groter dan 1200 bytes. Zo niet: zie *Known pitfalls* in de README | ✓ |
| I5 | Standaardtest Suricata (regel 2100498) | `ssh 192.168.1.4 "curl -s -o /dev/null -H 'X-Test: uid=0(root) gid=0(root)' http://example.com/"`, daarna `ssh 192.168.13.5 'sudo grep -i "id check" /var/log/suricata/fast.log'` | `GPL ATTACK_RESPONSE id check returned root` met bron 192.168.1.4 | ✓ |
| I6 | Poortscan gedetecteerd | Na H5: `ssh 192.168.13.5 'sudo grep -i scan /var/log/suricata/fast.log \| tail -5'` | Eén of meer ET SCAN-meldingen met je publieke IP | ☐ |
| I7 | VPN-verkeer zichtbaar | Als medewerker01 E2 opnieuw doen, daarna `ssh 192.168.13.5 'sudo jq -c "select(.src_ip|startswith(\"10.8.\"))" /var/log/suricata/eve.json \| tail -3'` | Regels met een bronadres 10.8.x.x | ☐ |
| I8 | Alleen de toegangspunten mogen naar de tunnel | `ssh 192.168.13.5 'sudo ufw status \| grep 4789'` | 2 regels: 192.168.1.4 en 192.168.1.5 | ✓ |

## 8. Afronding

| ID | Stap | ✓ |
|---|---|---|
| F1 | Eigen IP uit `partner_ip_ranges` en `proxy_sftp_allowed_from` halen (als T0.1 is gedaan), committen | ☐ |
| F2 | Bewijsmateriaal (output, screenshots) opslaan bij het verslag | ☐ |
| F3 | Mislukte tests noteren met oorzaak en oplossing | ☐ |
| F4 | Eventueel: VPN uit, `terraform destroy`, `git restore ansible/inventory.ini` | ☐ |

## Bevindingen

| Test-ID | Wat ging er mis | Oorzaak | Oplossing |
|---|---|---|---|
| I5 | testmynids.org gaf geen antwoord (`Could not resolve host`) | De dienst testmynids.org bestaat niet meer | Eigen testverzoek met dezelfde inhoud (`uid=0(root)`) in een HTTP-header; regel 2100498 matcht op die inhoud in elk pakket |
| I4 | Risico op verloren fragmenten (VXLAN +50 bytes) | – | Getest: pakketten tot 1536 bytes komen aan, fragmentatie werkt in Azure |
| I1–I5 | Veel meldingen van 168.63.129.16 (`SURICATA STREAM`, `HTTP unable to match`) | Intern platformverkeer van Azure (WireServer), wijkt af van standaard TCP/HTTP | Later onderdrukken met een suppress-regel (tuning) |
