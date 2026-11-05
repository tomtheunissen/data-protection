# Opdracht: opstarten + verbindingstests ZKOO PoC (blok N)

Je helpt Tom met een extra testronde van de ZKOO-PoC (Azure, Terraform, Ansible): **alle onderlinge verbindingen tussen de systemen**. De omgeving staat er al (uitrol van 29-10-2026), maar de VM's zijn waarschijnlijk uitgeschakeld door de dagelijkse shutdown van 19:00. Jij start alles weer op, controleert dat alles draait en voert daarna de tests uit.

Werk in de repo `~/Documents/GitHub/data-protection`. Achtergrond staat in Obsidian (vault `ai-memory`, map `10 Projecten/School/ZKOO Data Protection/`): lees eerst `ZKOO - Overzicht`, `ZKOO - Architectuur` (NSG-regels) en `ZKOO - Uitrol en beheer`. Het testplan staat in `docs/testplan.md`, het testscript in `tests/connectivity.sh`.

## Regels

- Antwoord Tom in het Nederlands. Code, comments en commitberichten in het Engels.
- **Nooit** `terraform plan`, `apply` of `destroy`. Alleen lezen uit Terraform mag (`terraform output`).
- VM's starten mag (`az vm start`), dat verandert niets aan de configuratie. Verder geen wijzigingen aan de infra (geen NSG-regels, geen Ansible-wijzigingen). Wijkt iets af van wat verwacht wordt: output bewaren, als bevinding noteren en aan Tom melden. Niet zelf repareren.
- Beheer gaat altijd via de jump host `vm-mgmt-01` (192.168.13.4):
  - commando op mgmt: `ssh -i ~/.ssh/id_rsa azureadmin@192.168.13.4 '<commando>'`
  - commando op een andere VM vanaf de laptop: `ssh -i ~/.ssh/id_rsa -J azureadmin@192.168.13.4 azureadmin@<ip> '<commando>'`
  - Gebruik `-o StrictHostKeyChecking=accept-new`. Krijg je `REMOTE HOST IDENTIFICATION HAS CHANGED`? Dan is de VM bij de uitrol van 29-10 opnieuw gemaakt: `ssh-keygen -R <ip>` en opnieuw proberen. Meld het in je samenvatting.
- Geen geheimen (wachtwoorden, TOTP, sleutels) in bewijsbestanden, het testplan of Git.
- `git commit` mag, maar vraag Tom vóór elke `git push`. Controleer na een push met `git log --oneline -1 origin/main` dat hij echt is aangekomen.
- **De VPN en de TOTP-codes bedient Tom zelf.** Stop bij elke ⏸ en wacht tot Tom bevestigt. Controleer daarna zelf: `ifconfig | grep "inet 10.8"` (tom = 10.8.4.10, niets = VPN uit).
- Plak geen commando's met `# commentaar` erachter in Tom's terminal (zsh breekt daarop).
- Vertel Tom per stap kort het resultaat (✅/❌ en de kernregel van de output).

## Omgeving (uitrol van 29-10-2026)

Lees de waarden zelf uit (map `terraform`), dan weet je zeker dat ze kloppen:

```bash
cd ~/Documents/GitHub/data-protection/terraform
KV=$(terraform output -raw key_vault_name)
P=$(terraform output -raw proxy_public_ip)
V=$(terraform output -raw vpn_public_ip)
echo $KV $P $V
```

Verwacht: `kv-zkoo-xrrd 20.107.7.53 20.123.199.46`. De publieke IP's zijn statisch, dus ze blijven gelijk na het herstarten.

| VM | IP | VM | IP |
|---|---|---|---|
| vm-proxy-01 | 192.168.1.4 | vm-ftp-01 | 192.168.4.7 |
| vm-vpn-01 | 192.168.1.5 | vm-app-01 | 192.168.8.4 |
| vm-web-01 | 192.168.4.4 | vm-fs-01 | 192.168.8.5 |
| vm-web-02 | 192.168.4.5 | vm-mgmt-01 | 192.168.13.4 |
| vm-media-01 | 192.168.4.6 | vm-ids-01 | 192.168.13.5 |
| pep-sensitivedata | 192.168.14.4 | pep-sql | 192.168.14.5 |
| pep-webapp | 192.168.14.6 | | |

## Bewijs

- Sla elke uitvoer op in `bewijs/<ID>-<ddmm>.txt` met `| tee`. Gebruik de datum van vandaag (`date +%d%m`), dus bijvoorbeeld `bewijs/N1-3110.txt`.
- Begin elk bestand met een regel met de datum/tijd en het commando.

---

## Fase 0 – Opstarten (laptop, VPN mag uit)

1. Controleer dat de Azure CLI is ingelogd: `az account show --query name -o tsv` → `Data Protection`. Zo niet: vraag Tom om `az login`.
2. Status van de VM's:
   ```bash
   az vm list -d -g 2026_KE06_KDB1_casusgroep_04 --query "[].{name:name, power:powerState}" -o table
   ```
3. Staan er VM's op `VM deallocated` of `VM stopped`? Start ze allemaal tegelijk:
   ```bash
   az vm start --ids $(az vm list -g 2026_KE06_KDB1_casusgroep_04 --query "[].id" -o tsv)
   ```
   Dit duurt een paar minuten. Herhaal stap 2 tot alle tien de VM's op `VM running` staan.
4. Controleer of de publieke IP's gelijk zijn gebleven (`terraform output`, zie hierboven).
5. Wacht daarna nog 2 minuten, zodat de services op de VM's (Docker, OpenVPN, Suricata, de mirror) opgestart zijn.
6. Snelle controle van buitenaf:
   ```bash
   curl -sk https://$P/ | grep Served
   curl -sk -o /dev/null -w "%{http_code}\n" https://$P/app/
   curl -sk https://$P/media/System/Info/Public
   ```
   Verwacht: `vm-web-02`, `200` en `"StartupWizardCompleted":true`. Sla dit op als `bewijs/N0-<ddmm>.txt`.

## Fase 1 – ⏸ VPN als **tom**

Tom verbindt in OpenVPN Connect met het profiel `20.123.199.46 [tom]` en de TOTP-code. Controleer daarna `10.8.4.10`.

7. **Services na de herstart (N0).** Controleer of alles na het opstarten vanzelf weer draait. Voer elke regel uit en sla alles samen op in `bewijs/N0-services-<ddmm>.txt`:
   - mgmt: `ssh -i ~/.ssh/id_rsa azureadmin@192.168.13.4 'hostname; cd ~/data-protection && git pull --quiet && git log --oneline -1'`
   - proxy: `sudo docker ps --format '{{.Names}} {{.Status}}'` en `systemctl is-active zkoo-mirror`
   - vpn: `systemctl is-active openvpn-server@server dnsmasq zkoo-mirror`
   - web-01: `sudo docker ps --format '{{.Names}} {{.Status}}'` en `findmnt /mnt/medical-files`
   - web-02, app-01, fs-01, media-01: `sudo docker ps --format '{{.Names}} {{.Status}}'`
   - ftp-01: `systemctl is-active ssh`
   - ids-01: `systemctl is-active zkoo-ids-tap suricata zkoo-ids-health.timer`
   
   Verwacht: alle containers `Up`, alle services `active`, de share gemount. Iets niet actief? Niet zelf starten: eerst melden aan Tom (dat is een bevinding: dienst start niet vanzelf na een herboot).

8. **N1 – Segmentatiematrix.** Het script staat in de repo en is net op mgmt binnengehaald met `git pull`. Draai het op mgmt en haal de uitvoer naar de laptop:
   ```bash
   ssh -i ~/.ssh/id_rsa azureadmin@192.168.13.4 'bash ~/data-protection/tests/connectivity.sh matrix' | tee bewijs/N1-<ddmm>.txt
   ```
   Het script logt vanaf mgmt in op elke VM en probeert vanaf daar elke andere VM en elk private endpoint op de relevante poorten (22, 443, 445, 1433, 2222, 8096). Per regel: verwacht (`open`/`blocked`), gemeten (`open`/`refused`/`timeout`) en `PASS`/`FAIL`. De laatste regel geeft het totaal.
   - Verwacht: **0 FAIL**. De 16 toegestane stromen staan in het script (`ALLOWED`) en komen uit de NSG-regels in `terraform/security.tf`.
   - Bij een `FAIL`: zoek uit of het ontwerp of het script niet klopt. Vergelijk de regel met de NSG-regels in `terraform/security.tf` en de ufw-regels (`sudo ufw status` op de doel-VM). Meld het aan Tom met je analyse. Pas niets aan.
   - `refused` betekent: het netwerkpad is open, maar er luistert niets. Bij een stroom die `blocked` hoort te zijn, is dat een FAIL, want het netwerk laat het verkeer toe.

9. **N2 – Uitgaand verkeer naar internet.**
   ```bash
   ssh -i ~/.ssh/id_rsa azureadmin@192.168.13.4 'bash ~/data-protection/tests/connectivity.sh egress' | tee bewijs/N2-<ddmm>.txt
   ```
   Waarschijnlijk krijgt elke VM `200`: er is geen filtering op uitgaand verkeer. Dat is **geen** fout in de PoC, maar wel een bevinding: een aanvaller op een server kan data naar buiten sturen. Noteer dat met als productieadvies: uitgaand verkeer beperken met Azure Firewall of uitgaande NSG-regels (alleen updates, Docker-registries en Azure-diensten toestaan).

10. **N3 – Private DNS vanaf elke VM.**
    ```bash
    ssh -i ~/.ssh/id_rsa azureadmin@192.168.13.4 'bash ~/data-protection/tests/connectivity.sh dns' | tee bewijs/N3-<ddmm>.txt
    ```
    Verwacht op elke VM: `sql-zkoo-01=192.168.14.5`, `stzkoosensitive01=192.168.14.4`, `app-zkoo-02=192.168.14.6`. Dat laat zien dat ook interne systemen nooit via de publieke route naar de PaaS-diensten gaan.

11. **N4 – Rooktest van de routes** (kort, om te zien dat alles na de herstart werkt). Vanaf de laptop, VPN mag aan blijven (de proxy is publiek):
    ```bash
    curl -sk -o /dev/null -w "U2 %{http_code}\n" https://$P/portaal/
    curl -sk -o /dev/null -w "H1 %{http_code}\n" "https://$P/portaal/?id=1'%20OR%20'1'='1"
    curl -sk -o /dev/null -w "M4 %{http_code}\n" https://$P/media
    curl -sk -o /dev/null -w "W3 %{http_code}\n" "https://$P/app/?id=1'%20OR%20'1'='1"
    ```
    Verwacht: `U2 200`, `H1 403`, `M4 301`, `W3 403`. En op ids: `systemctl list-timers zkoo-ids-health.timer --no-pager` (timer actief) en `sudo tail -3 /var/log/zkoo-ids-health.log` (geen nieuwe ALERT na het opstarten, of een ALERT direct na de boot gevolgd door RECOVERED). Sla alles op als `bewijs/N4-<ddmm>.txt`.

## Afronding

1. Voeg in `docs/testplan.md` een nieuw blok toe, **na** blok 7b en **vóór** `## 8. Afronding`, in dezelfde opmaak als de andere blokken:
   ```
   ## 7c. Onderlinge verbindingen (segmentatie)

   Op mgmt via `tests/connectivity.sh`, verbonden als **tom**.

   | ID | Test | Commando | Verwacht | ✓ |
   |---|---|---|---|---|
   | N0 | Alles start vanzelf na de dagelijkse shutdown | ... | ... | ✓/✗ |
   | N1 | Segmentatiematrix (oost-west) | ... | 0 FAIL | ✓/✗ |
   | N2 | Uitgaand verkeer naar internet | ... | Bevinding: niet gefilterd | ✓ (gemeten) |
   | N3 | Private DNS vanaf elke VM | ... | Private IP's | ✓/✗ |
   | N4 | Rooktest routes na herstart | ... | 200/403/301/403 | ✓/✗ |
   ```
   Vul de commando's en de verwachte uitkomst echt in. Zet de bevindingen (minimaal N2, en elke FAIL) in de tabel *Bevindingen*.
2. Werk in Obsidian `ZKOO - Testplan en resultaten` bij (een sectie *Aanvulling <datum>* met de resultaten en bevindingen) en vink in `ZKOO - TODO` dit onderdeel af.
3. Commit (`test: connectivity and segmentation tests (N0-N4)`), inclusief `tests/connectivity.sh` als dat nog niet gecommit is, en vraag Tom om te pushen.
4. Geef Tom een korte samenvatting: aantal PASS/FAIL in de matrix, de bevindingen en wat er eventueel niet vanzelf opstartte.
5. Herinner Tom eraan dat de VM's om 19:00 weer automatisch uitgaan.

**Laat F1 (het IP van Tom weghalen) en `terraform destroy` liggen: dat beslist Tom zelf.**
