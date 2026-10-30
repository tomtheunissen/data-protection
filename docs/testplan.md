# Testplan ZKOO PoC

Dit testplan controleert na een volledige uitrol of elke route uit de SOLL doet wat hij moet doen, ook de dingen die **niet** mogen. Vink elke test af en bewaar de output als bewijs voor het verslag, bijvoorbeeld met `| tee bewijs/<test-id>.txt` of een screenshot.

**Datum:** 27-10-2026 (tweede ronde, voortgezet 28-10-2026) **Uitgevoerd door:** Tom 
Eerste volledige ronde: 23-10-2026 door Tom Theunissen.

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
| T0.1 | Optioneel, voor test P4: zet je eigen publieke IP (`curl -4 ifconfig.me`) tijdelijk als `/32` in `partner_ip_ranges` (Terraform) én `proxy_sftp_allowed_from` (Ansible). Commit en push. | Beide lijsten bevatten je IP | ✓ |
| T0.2 | `git status` op je laptop | `working tree clean`, alles gepusht | ✓ |

## 1. Uitrol

| ID | Stap | Verwacht | ✓ |
|---|---|---|---|
| T1.1 | `terraform apply` | `Apply complete!`, 0 errors | ✓ |
| T1.2 | Bootstrap volgen met `tail -5 /var/log/zkoo-bootstrap.log` (Run Command) | `failed=0` voor vm-mgmt-01 en vm-vpn-01, daarna `Bootstrap finished` | ✓ |
| T1.3 | VPN-profielen en TOTP ophalen uit `$KV` (tom en medewerker01, allebei met QR-code) | `.ovpn`-bestanden gedownload, beide QR-codes gescand | ✓ |
| T1.4 | Verbinden als tom, `ssh-keygen -R 192.168.13.4`, inloggen op mgmt, `sudo reboot` | Ingelogd; na de reboot opnieuw ingelogd | ✓ |
| T1.5 | Op mgmt: `git pull`, collections installeren, playbook met `--limit proxy,webservers,media,sftp,appserver,fileserver,ids,vpn` | `failed=0` en `unreachable=0` voor elke VM | ✓ |
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
| U4 | HTTPS in de browser | `https://<proxy-ip>/` openen | Pagina laadt (na de certificaatwaarschuwing) | ✓ |

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
| H9 | Geen softwareversie zichtbaar | `curl -skI https://$P/ \| grep -iE '^(server\|x-powered-by):'` | Geen uitvoer |✓ |

## 4b. DVWA: aanvallen met en zonder WAF

Alleen tijdens deze test: zet `web_dvwa_enabled: true` in `ansible/host_vars/vm-web-01.yml`, commit en push, en draai op mgmt de play met `--limit webservers`. Zet het na D7 weer uit.

| ID | Test | Commando | Verwacht | ✓ |
|---|---|---|---|---|
| D1 | Wachtwoord in Key Vault, niet in Git | Lengte: `az keyvault secret show --vault-name $KV --name dvwa-db-password --query value -o tsv \| tr -d '\n' \| wc -c`. Config: `git grep -nE "dvwa_db_password:\s*\S" -- ansible/host_vars ansible/group_vars`. Historie: `git log --oneline -S <oud-wachtwoord>` | Secret = 24 tekens; `git grep` vindt niets in de config. Let op: `git log` toont het oude wachtwoord nog in de historie → bevinding | ✓ |
| D2 | Compose-bestand alleen voor root | Op mgmt: `ssh 192.168.4.4 'sudo stat -c "%a %U" /opt/zkoo/web/compose.yml'` | `600 root` | ✓ |
| D3 | DVWA via de WAF | Browser: `https://$P/portaal/dvwa/`, inloggen met `admin` / `password`, *Create / Reset Database*, opnieuw inloggen, *DVWA Security* → *Low* | Loginpagina en menu laden, links werken | ✓ |
| D4 | SQL-injectie via de WAF | In *SQL Injection*: `1' OR '1'='1` | `403 Forbidden` van de WAF | ✓ |
| D4-XSS | XSS via de WAF | In *XSS (Reflected)*: `<script>alert('xss')</script>` | `403 Forbidden` van de WAF | ✓ |
| D5 | Tunnel zonder WAF | Laptop, VPN als tom: `ssh -i ~/.ssh/id_rsa -J azureadmin@192.168.13.4 -L 8444:127.0.0.1:443 azureadmin@192.168.4.4`, dan `https://localhost:8444/dvwa/` en weer *Low* | DVWA laadt | ✓ |
| D6 | SQL-injectie zonder WAF | Zelfde invoer als D4 | Alle gebruikers uit de database verschijnen: de aanval lukt | ✓ |
| D6-XSS | XSS zonder WAF | In *XSS (Reflected)*: `<script>alert('xss')</script>` | Er verschijnt een alert-venster (ongefilterd teruggekaatst): de aanval lukt | ✓ |
| D7 | DVWA weer uit | `web_dvwa_enabled: false`, play `webservers` opnieuw, dan `curl -sk -o /dev/null -w "%{http_code}\n" https://$P/portaal/dvwa/` | `404` | ✓ |

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

Verbonden als **medewerker01**. Net als beheerders vullen medewerkers de TOTP-code van 6 cijfers in als wachtwoord.

| ID | Test | Commando | Verwacht | ✓ |
|---|---|---|---|---|
| E1 | VPN met geldige TOTP | Verbinden met de code uit de app | Verbonden, adres in 10.8.0.0/22 | ✓ |
| E1b | VPN met **foute** TOTP | Verbinden met code `000000` | Verbinding geweigerd (`AUTH_FAILED`) | ✓ |
| E2 | Appserver | `curl -sk https://192.168.8.4/` | Pagina van vm-app-01 | ✓ |
| E3 | Fileserver: verbinden | Wachtwoord: `az keyvault secret show --vault-name $KV --name smb-password-medewerker01 --query value -o tsv`. Finder → Ga → Verbind met server → `smb://192.168.8.5/zkoo-data` | Share geopend | ✓ |
| E4 | Fileserver: schrijven | Een bestand naar de share slepen | Bestand staat erop | ✓ |
| E5 | Fileserver: fout wachtwoord | Opnieuw verbinden met een fout wachtwoord | Geweigerd | ✓ |
| E6 | Medewerker kan **niet** bij de jump host | `nc -vz -G 5 192.168.13.4 22` | Timeout | ✓ |
| E7 | Medewerker kan **niet** bij het frontend | `nc -vz -G 5 192.168.4.4 443` | Timeout | ✓ |
| E8 | Bestand op de server | Als admin op mgmt: `ssh 192.168.8.5 'sudo ls -l /srv/samba/zkoo-data'` | Bestand van E4, groep `1500` | ✓ |

## 6b. Medische bestanden (Azure Files via private endpoint)

Verbonden als **tom**, op mgmt.

| ID | Test | Commando | Verwacht | ✓ |
|---|---|---|---|---|
| S1 | Share gemount op het portaal | `ssh 192.168.4.4 'findmnt /mnt/medical-files'` | Type `cifs`, opties met `vers=3.1.1` en `seal` | ✓ |
| S2 | Via het private endpoint | `ssh 192.168.4.4 'getent hosts stzkoosensitive01.file.core.windows.net'` | 192.168.14.4 | ✓ |
| S3 | Schrijven | `ssh 192.168.4.4 'sudo touch /mnt/medical-files/testbestand && sudo ls -l /mnt/medical-files'` | `testbestand` staat erop | ✓ |
| S4 | Sleutel alleen leesbaar voor root | `ssh 192.168.4.4 'sudo stat -c "%a %U" /etc/smbcredentials/stzkoosensitive01.cred'` | `600 root` | ✓ |
| S5 | Een andere VM kan **niet** bij de share | `ssh 192.168.4.5 'timeout 5 bash -c "</dev/tcp/192.168.14.4/445" && echo open \|\| echo geblokkeerd'` | `geblokkeerd` (nsg-pep) | ✓ |
| S6 | Geen publieke toegang | Laptop, VPN **uit**: `nc -vz -G 5 stzkoosensitive01.file.core.windows.net 445` | Mislukt (publieke toegang staat uit) | ✓ |

## 6c. Trainingsvideo's (Jellyfin)

Vanaf je laptop (VPN mag uit) en als **tom** op mgmt.

| ID | Test | Commando | Verwacht | ✓ |
|---|---|---|---|---|
| M1 | Wizard is afgerond | `curl -sk https://$P/media/System/Info/Public` | JSON met `"StartupWizardCompleted":true` |✓ |
| M2 | Wachtwoord in Key Vault | `az keyvault secret show --vault-name $KV --name jellyfin-admin-password --query value -o tsv` | Wachtwoord van 24 tekens | ✓ |
| M3 | Inloggen via de WAF | Browser: `https://$P/media/`, inloggen als `zkoo-admin` | Startpagina met de bibliotheek *Training* | ✓ |
| M4 | Doorverwijzing zonder slash | `curl -sk -o /dev/null -w "%{http_code} %{redirect_url}\n" https://$P/media` | `301` naar `/media/` | ✓ |
| M5 | Niet rechtstreeks bereikbaar | Laptop, VPN als tom: `nc -vz -G 5 192.168.4.6 8096`. Op mgmt: `timeout 5 bash -c "</dev/tcp/192.168.4.6/8096" && echo open \|\| echo geblokkeerd` | Timeout en `geblokkeerd`: alleen de proxy mag naar 8096 | ✓ |
| M6 | Aanval op /media/ | `curl -sk -o /dev/null -w "%{http_code}\n" "https://$P/media/?id=1'%20OR%20'1'='1"` | `403` van de WAF | ✓ |
| M7 | Video afspelen | Op mgmt een testvideo naar `/opt/zkoo/media/library` op vm-media-01 kopiëren, in Jellyfin *Scan All Libraries*, video afspelen | Video speelt af via `/media/` | ✓ |

## 7. Intrusion detection

Verbonden als **tom**, op mgmt.

| ID | Test | Commando | Verwacht | ✓ |
|---|---|---|---|---|
| I1 | Services draaien | `ssh 192.168.13.5 'systemctl is-active zkoo-ids-tap suricata'` | 2× `active` | ✓ |
| I2 | Mirror draait op beide toegangspunten | `ssh 192.168.1.4 'systemctl is-active zkoo-mirror'` en hetzelfde voor `192.168.1.5` | `active` | ✓ |
| I3 | Kopieën komen aan | `ssh 192.168.13.5 'sudo tcpdump -ni vxmirror -c 20'` (terwijl je U1 draait) | Pakketten van en naar 192.168.1.4 | ✓ |
| I4 | Grote pakketten komen aan | `ssh 192.168.13.5 'sudo timeout 30 tcpdump -ni vxmirror -c 5 greater 1200'` (draai intussen `ssh 192.168.1.4 'curl -s -o /dev/null https://www.microsoft.com'`) | Pakketten groter dan 1200 bytes. Zo niet: zie *Known pitfalls* in de README | ✓ |
| I5 | Standaardtest Suricata (regel 2100498) | `ssh 192.168.1.4 "curl -s -o /dev/null -H 'X-Test: uid=0(root) gid=0(root)' http://example.com/"`, daarna `ssh 192.168.13.5 'sudo grep -i "id check" /var/log/suricata/fast.log'` | `GPL ATTACK_RESPONSE id check returned root` met bron 192.168.1.4 | ✓ |
| I6 | Poortscan gedetecteerd | Na H5: `ssh 192.168.13.5 "sudo grep <eigen-ip> /var/log/suricata/fast.log \| sed 's/.*\] \(.*\) \[\*\*\].*/\1/' \| sort \| uniq -c"` | Meldingen met je publieke IP als bron | ✓ (zie Bevindingen) |
| I7 | VPN-verkeer zichtbaar | Als medewerker01 E2 en E3 doen, daarna `ssh 192.168.13.5 'sudo jq -c "select((.src_ip // \"\") \| startswith(\"10.8.0.\")) \| {timestamp, src_ip, dest_ip, dest_port, event_type}" /var/log/suricata/eve.json \| tail -5'` | Regels met bronadres 10.8.0.x naar 192.168.8.4/.5 | ✓ |
| I8 | Alleen de toegangspunten mogen naar de tunnel | `ssh 192.168.13.5 'sudo ufw status \| grep 4789'` | 2 regels: 192.168.1.4 en 192.168.1.5 | ✓ |
| I9 | WireServer onderdrukt | `ssh 192.168.13.5 'sudo grep -c 168.63.129.16 /var/log/suricata/fast.log'` (na de andere I-tests) | `0`, terwijl de meldingen van I5 en I6 er wel staan | ✓ |
| I10 | Bewaking draait | `ssh 192.168.13.5 'systemctl is-active zkoo-ids-health.timer && systemctl list-timers zkoo-ids-health.timer --no-pager'` | `active`, volgende run binnen 5 minuten | ✓ |
| I11 | Melding als Suricata stopt | `ssh 192.168.13.5 'sudo systemctl stop suricata && sudo systemctl start zkoo-ids-health.service; sudo journalctl -t zkoo-ids-health --since "2 min ago" --no-pager'` | `ALERT: suricata is not running` (exit-status van de service is 1, dat hoort zo) | ✓ |
| I12 | Herstelmelding | `ssh 192.168.13.5 'sudo systemctl start suricata && sleep 20 && sudo systemctl start zkoo-ids-health.service; sudo tail -3 /var/log/zkoo-ids-health.log'` | `RECOVERED: ...` na de ALERT-regels | ✓ |

Tests zonder wijziging in de betreffende configuratie zijn op 27-10-2026 niet herhaald; hun resultaat is van 23-10-2026.

## 7b. WebAPP02 (app-zkoo-02 via de WAF)

Vanaf je laptop, VPN **uit**.

| ID | Test | Commando | Verwacht | ✓ |
|---|---|---|---|---|
| W1 | Bereikbaar via de WAF | `curl -sk -o /dev/null -w "%{http_code}\n" https://$P/app/` en in de browser `https://<proxy-ip>/app/` | `200`, standaardpagina van App Service | ✓ |
| W2 | Doorverwijzing zonder slash | `curl -sk -o /dev/null -w "%{http_code} %{redirect_url}\n" https://$P/app` | `301` naar `/app/` | ✓ |
| W3 | SQL-injectie | `curl -sk -o /dev/null -w "%{http_code}\n" "https://$P/app/?id=1'%20OR%20'1'='1"` | `403` van de WAF | ✓ |
| W4 | XSS | `curl -sk -o /dev/null -w "%{http_code}\n" "https://$P/app/?q=<script>alert(1)</script>"` | `403` van de WAF | ✓ |
| W5 | Niet rechtstreeks publiek bereikbaar | `curl -s -o /dev/null -w "%{http_code}\n" https://app-zkoo-02.azurewebsites.net/` | `403` (publieke toegang staat uit) | ✓ |

## 7c. Onderlinge verbindingen (segmentatie)

Op mgmt via `tests/connectivity.sh`, verbonden als **tom**. Uitgevoerd op 30-10-2026, na het opstarten van alle VM's na de dagelijkse shutdown. Bewijs: `bewijs/N*-3010.txt`.

| ID | Test | Commando | Verwacht | ✓ |
|---|---|---|---|---|
| N0 | Alles start vanzelf na de dagelijkse shutdown | `az vm start --ids $(az vm list -g 2026_KE06_KDB1_casusgroep_04 --query "[].id" -o tsv)`, 2 minuten wachten, dan per VM `sudo docker ps --format '{{.Names}} {{.Status}}'` (proxy, web-01/02, media, app, fs), `systemctl is-active zkoo-mirror` (proxy), `systemctl is-active openvpn-server@server dnsmasq zkoo-mirror` (vpn), `findmnt /mnt/medical-files` (web-01), `systemctl is-active ssh` (ftp), `systemctl is-active zkoo-ids-tap suricata zkoo-ids-health.timer` (ids) | Alle containers `Up`, alle services `active`, share gemount via 192.168.14.4 | ✓ |
| N1 | Segmentatiematrix (oost-west) | `bash ~/data-protection/tests/connectivity.sh matrix`: vanaf elke VM elke andere VM en elk private endpoint op 22, 443, 445, 1433, 2222, 8096 | 0 FAIL: de 16 stromen uit `ALLOWED` (NSG-regels in `terraform/security.tf`) `open`, de rest `timeout` (geen `refused`) | ✓ (183 PASS, 0 FAIL; 16 open, 167 timeout) |
| N2 | Uitgaand verkeer naar internet | `bash ~/data-protection/tests/connectivity.sh egress` (`curl https://www.example.com` vanaf elke VM) | Bevinding: niet gefilterd | ✓ (gemeten: alle 10 VM's `200`) |
| N3 | Private DNS vanaf elke VM | `bash ~/data-protection/tests/connectivity.sh dns` | Private IP's op elke VM: `sql-zkoo-01=192.168.14.5`, `stzkoosensitive01=192.168.14.4`, `app-zkoo-02=192.168.14.6` | ✓ |
| N4 | Rooktest routes na herstart | Vanaf de laptop: `curl -sk -o /dev/null -w "%{http_code}\n"` op `https://$P/portaal/` (U2), `https://$P/portaal/?id=1'%20OR%20'1'='1` (H1), `https://$P/media` (M4), `https://$P/app/?id=1'%20OR%20'1'='1` (W3); op ids `systemctl list-timers zkoo-ids-health.timer --no-pager` en `sudo tail -3 /var/log/zkoo-ids-health.log` | 200/403/301/403, timer actief, geen ALERT zonder RECOVERED | ✓ |

## 7d. Laatste controles (TLS, logging, offboarding, SQL)

Uitgevoerd op 30/31-10-2026 (zelfde uitrol). C1 en X1 deel 1 vanaf de laptop met de VPN **uit**; V1, X1 deel 2, Q1, L1, L2, R1 en R2 als **tom**; V2 en R2 deel 2 als **medewerker01**. Bewijs: `bewijs/<ID>-3010.*` en `bewijs/<ID>-3110.*`.

| ID | Test | Commando | Verwacht | ✓ |
|---|---|---|---|---|
| C1 | TLS-instellingen van de WAF | `nmap -Pn --script ssl-enum-ciphers -p 443 $P` | Alleen TLS 1.2 en 1.3, geen TLS 1.0/1.1/SSL, `least strength: A` | ✓ (zie Bevindingen) |
| X1 | app-zkoo-03 alleen vanaf het proxy-IP | Laptop: `curl -s -o /dev/null -w "%{http_code}\n" https://app-zkoo-03.azurewebsites.net/`; daarna hetzelfde op vm-proxy-01 | Laptop `403`, proxy (uitgaand via 20.107.7.53) `200` | ✓ |
| V1 | Matrix vanaf de admin-pool | `bash tests/vpn-matrix.sh` op de laptop, verbonden als tom | 0 FAIL: alleen `mgmt-01:22` open, de rest `timeout` | ✓ (20 PASS, 0 FAIL) |
| V2 | Matrix vanaf de employee-pool | `bash tests/vpn-matrix.sh` op de laptop, verbonden als medewerker01 | 0 FAIL: alleen `app-01:443`, `fs-01:445` en `pep-sensitivedata:445` open | ✓ (20 PASS, 0 FAIL) |
| Q1 | SQL weigert inloggen met een SQL-wachtwoord | Op web-01: `sudo docker run --rm --entrypoint /opt/mssql-tools18/bin/sqlcmd mcr.microsoft.com/mssql/server:2022-latest -S tcp:sql-zkoo-01.database.windows.net,1433 -U zkoo-test -P <verzonnen> -C -l 15 -Q "SELECT 1"`, daarna `docker rmi`; ter ondersteuning `az sql server ad-only-auth get` | `Login failed ... Azure Active Directory only authentication is enabled` | ✓ (zie Bevindingen) |
| L1 | Logs van de fileshare in Log Analytics | Testbestand schrijven naar `/mnt/medical-files` op web-01, na 15 min `az monitor log-analytics query` op `StorageFileLogs`, daarna het testbestand verwijderen | `Write`/`Create` vanaf 192.168.4.4 op het tijdstip van schrijven | ✓ |
| L2 | SQL-auditing in Log Analytics | `az monitor log-analytics query` op `AzureDiagnostics`, `Category == 'SQLSecurityAuditEvents'` | De mislukte login uit Q1 met `succeeded_s = false` | ✓ |
| R1 | Ingetrokken certificaat wordt geweigerd | Op vm-vpn-01: `easyrsa --batch revoke medewerker01`, `easyrsa --batch gen-crl`, `install -m 640 -o root -g nogroup pki/crl.pem /etc/openvpn/server/crl.pem`; daarna verbinden met het oude profiel van medewerker01 + geldige TOTP; `journalctl -u openvpn-server@server` | Verbinding mislukt, log `VERIFY ERROR ... certificate revoked: CN=medewerker01` | ✓ (screenshot `R1-3010.png`) |
| R2 | Nieuw certificaat werkt weer | Op mgmt: `ansible-playbook -i /var/lib/zkoo/inventory.ini playbook.yml --limit vpn`; nieuw profiel uit Key Vault importeren; verbinden als medewerker01 | `failed=0`, `changed` bij *Build client certificates* voor medewerker01, nieuw serienummer, verbonden met 10.8.0.x | ✓ (10.8.0.2) |

## 8. Afronding

| ID | Stap | ✓ |
|---|---|---|
| F1 | Eigen IP uit `partner_ip_ranges` en `proxy_sftp_allowed_from` halen (als T0.1 is gedaan), committen | ☐ |
| F2 | Bewijsmateriaal (output, screenshots) opslaan bij het verslag | ✓ |
| F3 | Mislukte tests noteren met oorzaak en oplossing | ✓ (geen mislukte tests; afwijkingen staan bij Bevindingen) |
| F4 | Eventueel: VPN uit, `terraform destroy`, `git restore ansible/inventory.ini` | ☐ |

## Bevindingen

| Test-ID | Wat ging er mis | Oorzaak | Oplossing |
|---|---|---|---|
| I5 | testmynids.org gaf geen antwoord (`Could not resolve host`) | De dienst testmynids.org bestaat niet meer | Eigen testverzoek met dezelfde inhoud (`uid=0(root)`) in een HTTP-header; regel 2100498 matcht op die inhoud in elk pakket |
| I4 | Risico op verloren fragmenten (VXLAN +50 bytes) | – | Getest: pakketten tot 1536 bytes komen aan, fragmentatie werkt in Azure |
| I1–I5 | Veel meldingen van 168.63.129.16 (`SURICATA STREAM`, `HTTP unable to match`) | Intern platformverkeer van Azure (WireServer), wijkt af van standaard TCP/HTTP | Opgelost: suppress-regel in `threshold.config` (zie I9) |
| I6 | Geen ET SCAN-melding bij de nmap-scan | De NSG blokkeert 9998 van de 10.000 poorten vóór het verkeer de proxy (en dus de mirror) bereikt; Suricata ziet alleen 443 en 2222 | Scan wel gedetecteerd: 110 meldingen `SURICATA STREAM … RST invalid ack` van het scannende IP, het patroon van een nmap SYN-scan (SYN, SYN-ACK, RST). Defense in depth: NSG eerst, IDS daarna |
| I7 | – | – | De IDS legde ook een geblokkeerde SSH-poging van medewerker01 (10.8.0.2) naar de jump host vast. Pogingen die de NSG tegenhoudt, zijn dus toch zichtbaar |
| E1 | OpenVPN Connect eist een wachtwoord, ook voor medewerkers | De client maakt het veld verplicht; de server controleert het voor medewerkers niet | Opgelost: medewerkers gebruiken nu ook TOTP (zie E1 en E1b) |
| E3 | macOS probeert ook poort 139 (NetBIOS) | Standaardgedrag van macOS | Poort 139 is dicht; de container draait alleen smbd op 445 |
| T1.1 | Eerste `terraform apply` (27-10) faalde op het App Service-plan `asp-zkoo-01`: `409 Conflict, No available instances` | Tijdelijk capaciteitstekort bij Azure App Service in West Europe | Tweede `terraform apply` ongeveer 20 minuten later maakte alleen de 4 ontbrekende resources aan (plan, app-zkoo-02, app-zkoo-03, pep-webapp). Uitwijk als het blijft falen: andere SKU of andere regio voor het plan |
| M1 | `/media/System/Info/Public` is zonder inloggen bereikbaar en toont de Jellyfin-versie (10.11.5), een server-ID en het interne containeradres (172.18.0.2) | Standaardgedrag van Jellyfin: de webclient heeft dit endpoint nodig om te starten | Laag risico (informatie voor een aanvaller, geen toegang). Niet blokkeren in de PoC, anders laadt Jellyfin niet. Productieadvies: `/media/` alleen via de VPN aanbieden |
| D1 | Het oude DVWA-databasewachtwoord staat nog in de Git-historie (commits `6b266e0`, `acaac25`) | Het wachtwoord stond ooit hardcoded in de repo voordat het naar Key Vault verhuisde | De huidige config bevat geen geheim (waarde komt uit Key Vault, `no_log`) en de oude waarde is niet meer in gebruik. Productieadvies: historie opschonen met `git filter-repo` en secret scanning (bijv. gitleaks) in CI aanzetten |
| D3 | *Create / Reset Database* in DVWA gaf een 404 via de WAF | DVWA stuurt een root-relatieve redirect die nginx absoluut maakte (`absolute_redirect`), zonder het `/portaal`-prefix → `https://.../dvwa/setup.php` | Opgelost: `proxy_redirect` + `absolute_redirect off` op zowel vm-web-01 als de proxy. Stap 4 geeft daarna `Location: /portaal/dvwa/setup.php` |
| N2 | Alle 10 VM's bereiken het internet (`https://www.example.com` → `200`) | Er is geen filtering op uitgaand verkeer: de NSG's beperken alleen inkomend verkeer, uitgaand geldt de Azure-standaard (`AllowInternetOutBound`) | Geen fout in de PoC, wel een risico: een aanvaller op een server kan data naar buiten sturen (exfiltratie) of een C2-verbinding opzetten. Productieadvies: uitgaand verkeer beperken met Azure Firewall of uitgaande NSG-regels, en alleen updates, Docker-registries en Azure-diensten toestaan |
| N4 | Na het opstarten één `ALERT: no mirrored packets received on vxmirror` (23:00), om 23:06 gevolgd door `RECOVERED` | De eerste health check draaide voordat de mirror op proxy en vpn verkeer doorstuurde | Verwacht gedrag na een herstart. Productieadvies: een korte opstartperiode in de health check of de melding pas na twee mislukte checks versturen |
| C1 | nmap waarschuwt `Key exchange (dh 2048) of lower strength than certificate key`, en `cipher preference: client` | Op TLS 1.2 worden ook DHE-suites aangeboden en de server dwingt zijn eigen volgorde niet af | Laag risico: alle suites zijn AEAD en krijgen `A`, TLS 1.3 gebruikt zelfs X25519MLKEM768. Productieadvies: DHE-suites schrappen (alleen ECDHE) of `ssl_prefer_server_ciphers on` |
| Q1 | Het image `mcr.microsoft.com/mssql-tools18` uit het testvoorschrift bestaat niet (`not found`; `mssql-tools` geeft ook 404) | Microsoft publiceert de tools niet (meer) als los image | `sqlcmd` uit `mcr.microsoft.com/mssql/server:2022-latest` gebruikt (`--entrypoint`, `--rm`, image daarna verwijderd). Verbindingsbeleid `Default` (= Redirect binnen Azure) gaf géén timeout: de loginfout kwam binnen 2 seconden |
| L1 | `StatusText` is leeg in `StorageFileLogs` | De kolom wordt voor SMB-operaties niet gevuld | Geen probleem: operatie, tijd en bron-IP zijn er wel |
| L2 | Het bron-IP staat als IPv6 (`fd40:…:c0a8:404`) en `server_principal_name_s` is leeg | Private Link vertaalt het client-IP naar IPv6 (`c0a8:0404` = 192.168.4.4); de login is geweigerd vóór er een principal was | Bij het lezen van de audit-log het IPv4-adres uit de laatste 32 bits halen |
| R1 | Na het intrekken logt OpenVPN bij elke verbinding `CRL: cannot read CRL from file /etc/openvpn/server/crl.pem`, direct gevolgd door `CRL: loaded 1 CRLs` (ook voor tom). Vóór het intrekken stond alleen `loaded 1 CRLs` in de log | Niet vastgesteld | De CRL wordt wel geladen en toegepast (medewerker01 geweigerd, tom en de nieuwe medewerker01 verbinden). Uitzoeken vóór productie. NB: OpenVPN Connect toont de gebruiker alleen een algemene melding (*Required credentials are missing for the reconnection attempt*, `R1-3010.png`); het bewijs van de intrekking is de serverlog |
| R2 | De vpn-play zet bij elke run alle profielen en TOTP-geheimen opnieuw in Key Vault (`changed`) | Bekend gedrag sinds de idempotentietest van 27-10 (`changed=5` bij vm-vpn-01); de TOTP-geheimen worden eerst uit de bestaande waarden gelezen en blijven gelijk | Alleen *Build client certificates* voor medewerker01 was een echte wijziging. Offboarding/herstel kost: revoke + gen-crl + CRL installeren, en voor herstel één playbook-run en een nieuw profiel |
| D4 / D4-XSS | De WAF-log legt alleen de blokkerende CRS-regel `949110` vast (anomaly score: SQLi 8, XSS 23), niet de individuele detectieregels (941xxx/942xxx) | `SecAuditEngine RelevantOnly` met `SecAuditLog /dev/stdout` (Serial); de audit-map is leeg en de nginx-worker-stdout wordt niet opgevangen in `docker logs` | De 403-blokkade is wél aangetoond. Productieadvies: audit-log naar een opgevangen bestand/concurrent-map sturen voor per-regel-forensics |