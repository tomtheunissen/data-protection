# Opdracht: laatste testronde ZKOO PoC (blok 7d)

Je helpt Tom met de laatste testronde van de ZKOO-PoC (Azure, Terraform, Ansible). Dit zijn de beweringen uit het ontwerp die nog niet met een test zijn aangetoond. De omgeving staat er al (uitrol van 29-10-2026), maar de VM's zijn waarschijnlijk uitgeschakeld door de dagelijkse shutdown van 19:00. Jij start alles op, controleert dat het draait en voert de tests uit.

Werk in de repo `~/Documents/GitHub/data-protection`. Achtergrond staat in Obsidian (vault `ai-memory`, map `10 Projecten/School/ZKOO Data Protection/`): lees eerst `ZKOO - Overzicht`, `ZKOO - Architectuur` en `ZKOO - Testplan en resultaten` (vooral de aanvulling van 30-10, blok 7c). Het testplan staat in `docs/testplan.md`. Scripts: `tests/connectivity.sh` (op mgmt) en `tests/vpn-matrix.sh` (op de laptop).

## Overzicht van de tests

| ID | Test | Wat het aantoont |
|---|---|---|
| C1 | TLS-instellingen van de WAF | Alleen TLS 1.2/1.3 en sterke ciphers (data in transit) |
| X1 | app-zkoo-03 alleen vanaf het proxy-IP | De IP-beperking uit de docentfeedback werkt |
| V1 | Matrix vanaf de admin-pool (tom) | Beheerders komen alleen bij de jump host |
| V2 | Matrix vanaf de employee-pool (medewerker01) | Medewerkers komen alleen bij app, fileserver en Azure Files |
| Q1 | SQL weigert inloggen met een SQL-wachtwoord | Alleen Entra ID-authenticatie |
| L1 | Logs van de fileshare komen aan in Log Analytics | De logging uit het ontwerp werkt |
| L2 | SQL-auditing komt aan in Log Analytics | Idem, voor de database |
| R1 | Ingetrokken certificaat wordt geweigerd | Offboarding: toegang intrekken werkt |
| R2 | Nieuw certificaat werkt weer | Herstel na offboarding |

## Regels

- Antwoord Tom in het Nederlands. Code, comments en commitberichten in het Engels.
- **Nooit** `terraform plan`, `apply` of `destroy`. Alleen lezen uit Terraform mag (`terraform output`).
- VM's starten mag (`az vm start`). Verder verander je **niets** aan de infra, met twee uitzonderingen die in deze opdracht staan: **Q1** (een tijdelijke container op web-01) en **R1/R2** (certificaat intrekken en opnieuw uitgeven). Vraag Tom vóór elk van die twee om toestemming (⏸). Wijkt iets af van wat verwacht wordt: output bewaren, als bevinding noteren en aan Tom melden. Niet zelf repareren.
- Beheer gaat altijd via de jump host `vm-mgmt-01` (192.168.13.4):
  - commando op mgmt: `ssh -i ~/.ssh/id_rsa azureadmin@192.168.13.4 '<commando>'`
  - commando op een andere VM vanaf de laptop: `ssh -i ~/.ssh/id_rsa -J azureadmin@192.168.13.4 azureadmin@<ip> '<commando>'`
  - Gebruik `-o StrictHostKeyChecking=accept-new`. Krijg je `REMOTE HOST IDENTIFICATION HAS CHANGED`? Dan `ssh-keygen -R <ip>` en opnieuw proberen.
- Geen geheimen (wachtwoorden, TOTP, sleutels, profielen) in bewijsbestanden, het testplan of Git.
- `git commit` mag, maar vraag Tom vóór elke `git push`. Controleer na een push met `git log --oneline -1 origin/main`.
- **De VPN en de TOTP-codes bedient Tom zelf.** Stop bij elke ⏸ en wacht tot Tom bevestigt. Controleer daarna zelf: `ifconfig | grep "inet 10.8"` (tom = 10.8.4.10, medewerker01 = 10.8.0.x, niets = VPN uit).
- Plak geen commando's met `# commentaar` erachter in Tom's terminal (zsh breekt daarop).
- Vertel Tom per test kort het resultaat (✅/❌ en de kernregel van de output).

## Omgeving

```bash
cd ~/Documents/GitHub/data-protection/terraform
KV=$(terraform output -raw key_vault_name)
P=$(terraform output -raw proxy_public_ip)
V=$(terraform output -raw vpn_public_ip)
echo $KV $P $V
```

Verwacht: `kv-zkoo-xrrd 20.107.7.53 20.123.199.46`. Resourcegroep: `2026_KE06_KDB1_casusgroep_04`. Log Analytics-workspace: `log-zkoo-01`.

| VM | IP | VM | IP |
|---|---|---|---|
| vm-proxy-01 | 192.168.1.4 | vm-ftp-01 | 192.168.4.7 |
| vm-vpn-01 | 192.168.1.5 | vm-app-01 | 192.168.8.4 |
| vm-web-01 | 192.168.4.4 | vm-fs-01 | 192.168.8.5 |
| vm-web-02 | 192.168.4.5 | vm-mgmt-01 | 192.168.13.4 |
| vm-media-01 | 192.168.4.6 | vm-ids-01 | 192.168.13.5 |

## Bewijs

Sla elke uitvoer op in `bewijs/<ID>-<ddmm>.txt` met `| tee`, met de datum van vandaag (`date +%d%m`). Begin elk bestand met een regel met de datum/tijd en het commando.

---

## Fase 0 – Opstarten (laptop, VPN uit)

1. `az account show --query name -o tsv` → `Data Protection`. Zo niet: vraag Tom om `az login`.
2. Status: `az vm list -d -g 2026_KE06_KDB1_casusgroep_04 --query "[].{name:name, power:powerState}" -o table`
3. Staan er VM's niet op `VM running`? `az vm start --ids $(az vm list -g 2026_KE06_KDB1_casusgroep_04 --query "[].id" -o tsv)`. Herhaal stap 2 tot alle tien draaien, wacht daarna nog 2 minuten.
4. Snelle controle: `curl -sk https://$P/ | grep Served` → `vm-web-02`.

## Fase 1 – Tests zonder VPN (laptop, VPN uit)

5. **C1 – TLS van de WAF.**
   ```bash
   nmap -Pn --script ssl-enum-ciphers -p 443 $P | tee bewijs/C1-<ddmm>.txt
   ```
   Verwacht: alleen `TLSv1.2` en `TLSv1.3`, geen `TLSv1.0`/`TLSv1.1`/SSL, en de beoordeling (`least strength`) minimaal `A`. Ontbreekt `nmap`, vraag Tom om `brew install nmap`.

6. **X1 – app-zkoo-03, deel 1 (rechtstreeks vanaf internet).**
   ```bash
   curl -s -o /dev/null -w "laptop -> app-zkoo-03: %{http_code}\n" https://app-zkoo-03.azurewebsites.net/
   ```
   Verwacht: `403`, want alleen het publieke IP van de proxy mag erbij. Deel 2 volgt in fase 2.

## Fase 2 – ⏸ VPN als **tom**

Tom verbindt met het profiel `20.123.199.46 [tom]` en de TOTP-code. Controleer `10.8.4.10`.

7. **Voorbereiden op mgmt:** `ssh -i ~/.ssh/id_rsa azureadmin@192.168.13.4 'cd ~/data-protection && git pull --quiet && git log --oneline -1'`

8. **X1 – app-zkoo-03, deel 2 (vanaf de proxy).** Op vm-proxy-01:
   ```bash
   curl -s -o /dev/null -w "proxy -> app-zkoo-03: %{http_code}\n" https://app-zkoo-03.azurewebsites.net/
   ```
   Verwacht: `200`, want de proxy gaat naar buiten met zijn eigen publieke IP, en dat staat op de allowlist. Sla deel 1 en 2 samen op als `bewijs/X1-<ddmm>.txt`.

9. **V1 – Matrix vanaf de admin-pool.**
   ```bash
   bash tests/vpn-matrix.sh | tee bewijs/V1-<ddmm>.txt
   ```
   Verwacht: **0 FAIL**. Alleen `mgmt-01:22` is `open`, al het andere is `timeout`. Bij een FAIL: analyseren met de NSG-regels (`terraform/security.tf`) en de ufw-regels op de doel-VM, en melden aan Tom.

10. **L1 – voorbereiding.** Schrijf een testbestand naar de medische share. Daarmee ontstaat een logregel in Azure Files. Noteer de tijd:
    ```bash
    ssh -i ~/.ssh/id_rsa -J azureadmin@192.168.13.4 azureadmin@192.168.4.4 'date; sudo sh -c "date > /mnt/medical-files/la-test-$(date +%d%m%H%M).txt"; ls -l /mnt/medical-files | tail -3'
    ```

11. **⏸ Q1 – SQL alleen Entra-login.** Vraag Tom om toestemming. Je start op web-01 eenmalig een container met `sqlcmd` (`--rm`, hij verdwijnt daarna weer), en probeert in te loggen met een verzonnen SQL-gebruiker:
    ```bash
    ssh -i ~/.ssh/id_rsa -J azureadmin@192.168.13.4 azureadmin@192.168.4.4 'sudo docker run --rm mcr.microsoft.com/mssql-tools18 /opt/mssql-tools18/bin/sqlcmd -S tcp:sql-zkoo-01.database.windows.net,1433 -U zkoo-test -P "Not-A-Real-Passw0rd" -C -l 15 -Q "SELECT 1"; sudo docker rmi mcr.microsoft.com/mssql-tools18 >/dev/null'
    ```
    - Verwacht: een fout met `Login failed` en een melding dat alleen Azure Active Directory-/Entra-authenticatie is toegestaan. Dat laat zien dat inloggen met een wachtwoord niet kan.
    - Krijg je een timeout in plaats van een loginfout? Dan is dat een bevinding. Waarschijnlijke oorzaak: het verbindingsbeleid *Redirect* van Azure SQL gebruikt ook de poorten 11000–11999 naar het private endpoint, en nsg-pep staat alleen 1433 toe. **Niets aanpassen**, alleen analyseren en melden.
    - Sla de uitvoer op als `bewijs/Q1-<ddmm>.txt`. Deze mislukte login hoort straks ook bij L2.

12. **⏸ R1 – Certificaat van medewerker01 intrekken.** Vraag Tom om toestemming: medewerker01 kan daarna tijdelijk niet meer verbinden, tot R2. Op vm-vpn-01 (192.168.1.5):
    1. Versie en uitgangssituatie vastleggen:
       ```bash
       cd /etc/openvpn/easy-rsa && sudo ./easyrsa --version | head -2 && sudo stat -c "%a %U:%G" /etc/openvpn/server/crl.pem
       ```
       Is de versie lager dan 3.1? **Stop** en meld het aan Tom: dan werkt het herstel in R2 anders.
    2. Intrekken en de lijst met ingetrokken certificaten (CRL) publiceren. Gebruik bij `install` dezelfde rechten en eigenaar als de `stat` van stap 1 liet zien:
       ```bash
       cd /etc/openvpn/easy-rsa && sudo ./easyrsa --batch revoke medewerker01 && sudo ./easyrsa --batch gen-crl && sudo install -m <rechten> -o <eigenaar> -g <groep> pki/crl.pem /etc/openvpn/server/crl.pem && sudo openssl crl -in /etc/openvpn/server/crl.pem -noout -text | grep -A1 "Serial Number"
       ```
    3. **⏸ Tom** verbreekt de VPN en probeert te verbinden met het **oude** profiel van medewerker01, met een geldige TOTP-code. Verwacht: de verbinding mislukt. Tom maakt een screenshot (`bewijs/R1-<ddmm>.png`).
    4. **⏸ Tom** verbindt weer als tom. Haal daarna de serverlog op:
       ```bash
       sudo journalctl -u openvpn-server@server --since "15 min ago" --no-pager | grep -iE "revoked|crl|verify error|medewerker01"
       ```
       Verwacht: een regel dat het certificaat van medewerker01 is ingetrokken (`certificate revoked` / `VERIFY ERROR`). Sla dit op als `bewijs/R1-<ddmm>.txt`.

13. **R2 – Nieuw certificaat uitgeven.** De playbook maakt een nieuw certificaat voor medewerker01, omdat het oude uit `pki/issued` is verplaatst. Het TOTP-geheim blijft gelijk. Op mgmt:
    ```bash
    ssh -i ~/.ssh/id_rsa azureadmin@192.168.13.4 'cd ~/data-protection/ansible && ansible-playbook -i /var/lib/zkoo/inventory.ini playbook.yml --limit vpn' | tee bewijs/R2-playbook-<ddmm>.txt
    ```
    Verwacht: `failed=0`, en bij *Build client certificates* een `changed` voor medewerker01. Daarna op de laptop het nieuwe profiel ophalen (geen inhoud tonen):
    ```bash
    az keyvault secret download --vault-name $KV --name vpn-profile-medewerker01 --file ~/medewerker01.ovpn --overwrite
    ```
    Vraag Tom om in OpenVPN Connect het oude profiel van medewerker01 te verwijderen en `~/medewerker01.ovpn` opnieuw te importeren. De QR-code hoeft niet opnieuw.

14. **L1 en L2 – Logs in Log Analytics.** Wacht tot er minstens 15 minuten verstreken zijn sinds stap 10 en 11 (Azure heeft vertraging bij het binnenhalen van logs). Daarna op de laptop:
    ```bash
    WS=$(az monitor log-analytics workspace show -g 2026_KE06_KDB1_casusgroep_04 -n log-zkoo-01 --query customerId -o tsv)
    az monitor log-analytics query -w $WS --analytics-query "StorageFileLogs | where TimeGenerated > ago(3h) | project TimeGenerated, OperationName, StatusText, CallerIpAddress | order by TimeGenerated desc | take 15" -o table | tee bewijs/L1-<ddmm>.txt
    az monitor log-analytics query -w $WS --analytics-query "AzureDiagnostics | where Category == 'SQLSecurityAuditEvents' and TimeGenerated > ago(3h) | project TimeGenerated, action_name_s, succeeded_s, server_principal_name_s, client_ip_s | order by TimeGenerated desc | take 15" -o table | tee bewijs/L2-<ddmm>.txt
    ```
    - Verwacht bij L1: schrijfacties (zoals `Create`/`Write`/`PutRange`) vanaf het private IP van web-01 (192.168.4.4).
    - Verwacht bij L2: de mislukte login uit Q1 (`succeeded_s` = `false`).
    - Vraagt `az` om een extensie (`log-analytics`)? Installeer die: `az extension add --name log-analytics`.
    - Leeg resultaat? Wacht 10 minuten en probeer opnieuw, maximaal 3 keer. Blijft het leeg, dan is dat een bevinding (logs komen niet aan). Controleer dan of de diagnostische instellingen bestaan (`az monitor diagnostic-settings list --resource <id>`) en meld het aan Tom.

15. **Opruimen L1.** Verwijder het testbestand weer: `sudo rm /mnt/medical-files/la-test-*.txt` op web-01.

## Fase 3 – ⏸ VPN als **medewerker01** (met het nieuwe profiel)

Tom verbindt met het nieuwe profiel van medewerker01 en de TOTP-code. Controleer `10.8.0.x`.

16. **R2 – deel 2.** De verbinding werkt weer met het nieuwe certificaat. Leg vast: `ifconfig | grep "inet 10.8"` en `date`, en voeg die uitvoer toe aan `bewijs/R2-<ddmm>.txt`.

17. **V2 – Matrix vanaf de employee-pool.**
    ```bash
    bash tests/vpn-matrix.sh | tee bewijs/V2-<ddmm>.txt
    ```
    Verwacht: **0 FAIL**. Alleen `app-01:443`, `fs-01:445` en `pep-sensitivedata:445` zijn `open`, al het andere is `timeout`.

Daarna mag Tom de VPN uitzetten of weer als tom verbinden.

## Afronding

1. Voeg in `docs/testplan.md` een nieuw blok toe, **na** blok 7c en **vóór** `## 8. Afronding`, in dezelfde opmaak:
   ```
   ## 7d. Laatste controles (TLS, logging, offboarding, SQL)
   ```
   Met een regel per test (C1, X1, V1, V2, Q1, L1, L2, R1, R2): ID, test, commando (kort), verwacht en ✓/✗. Zet afwijkingen en opvallende dingen in de tabel *Bevindingen*.
2. Werk in Obsidian `ZKOO - Testplan en resultaten` bij (een sectie *Aanvulling <datum>* met resultaten en bevindingen) en vink in `ZKOO - TODO` dit onderdeel af.
3. Commit (`test: final checks C1, X1, V1-V2, Q1, L1-L2, R1-R2`), inclusief `tests/vpn-matrix.sh` als dat nog niet gecommit is. Vraag Tom om te pushen.
4. Geef Tom een korte samenvatting: wat geslaagd is, wat niet, de bevindingen, en of medewerker01 weer normaal werkt.
5. Herinner Tom eraan dat de VM's om 19:00 weer automatisch uitgaan.

**Laat F1 (het IP van Tom weghalen) en `terraform destroy` liggen: dat beslist Tom zelf.**
