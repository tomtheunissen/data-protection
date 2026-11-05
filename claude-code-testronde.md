# Opdracht: testronde ZKOO PoC (27-10-2026)

Je helpt Tom met de tweede testronde van de ZKOO-PoC (Azure, Terraform, Ansible). Werk in de repo `~/Documents/GitHub/data-protection`. Achtergrond staat in Obsidian (vault `ai-memory`, map `10 Projecten/School/ZKOO Data Protection/`): lees eerst `ZKOO - Overzicht`, `ZKOO - Testplan en resultaten` en `ZKOO - Uitrol en beheer`. Het volledige testplan met alle commando's staat in `docs/testplan.md`.

## Regels

- Antwoord Tom in het Nederlands. Code, comments en commitberichten in het Engels.
- **Nooit** `terraform plan`, `apply` of `destroy`. Alleen lezen uit Terraform mag (`terraform output`).
- Beheer gaat altijd via de jump host `vm-mgmt-01` (192.168.13.4). Een VM bereik je zo, vanaf de laptop:
  `ssh -i ~/.ssh/id_rsa -J azureadmin@192.168.13.4 azureadmin@<ip> '<commando>'`
  Commando's op mgmt zelf: `ssh -i ~/.ssh/id_rsa azureadmin@192.168.13.4 '<commando>'`
- Ansible draait alleen op mgmt: `cd ~/data-protection && git pull && cd ansible && ansible-playbook -i /var/lib/zkoo/inventory.ini playbook.yml --limit <groep>`
- Geen geheimen (wachtwoorden, TOTP, sleutels) in bewijsbestanden, het testplan of Git. Laat bij wachtwoorden alleen de lengte zien (`| wc -c`), niet de waarde.
- `git commit` mag, maar vraag Tom vóór elke `git push`.
- **De VPN en de TOTP-codes bedient Tom zelf.** Stop bij elke ⏸ en wacht tot Tom bevestigt dat de juiste verbinding aanstaat. Controleer daarna zelf: `ifconfig | grep "inet 10.8"` (tom = 10.8.4.10, medewerker01 = 10.8.0.x, niets = VPN uit).
- Als iets anders uitvalt dan verwacht: niet zelf gaan repareren in de infra. Sla de output op, noteer het als bevinding en meld het aan Tom.
- Vertel Tom per test kort het resultaat (✅/❌ en de kernregel van de output).

## Omgeving (uitrol van 27-10-2026)

Zet deze variabelen in elke nieuwe shell (of lees ze uit met `cd terraform && terraform output -raw ...`):

```bash
KV=kv-zkoo-d34m
P=20.160.79.1
V=20.4.24.166
```

| VM | IP |
|---|---|
| vm-proxy-01 | 192.168.1.4 |
| vm-vpn-01 | 192.168.1.5 |
| vm-web-01 (portaal) | 192.168.4.4 |
| vm-web-02 (website) | 192.168.4.5 |
| vm-media-01 | 192.168.4.6 |
| vm-ftp-01 | 192.168.4.7 |
| vm-app-01 | 192.168.8.4 |
| vm-fs-01 | 192.168.8.5 |
| vm-mgmt-01 | 192.168.13.4 |
| vm-ids-01 | 192.168.13.5 |

## Bewijs

- Sla de output van elke test op in `bewijs/<ID>-2710.txt`, met `| tee bewijs/<ID>-2710.txt`. Begin elk bestand met een regel met het commando en de datum/tijd (`date`).
- Screenshots maakt Tom; spreek met hem de naam af: `bewijs/<ID>-2710.png`.

## Al gedaan in deze ronde (niet opnieuw)

T0.1–T1.6, A1, H9, M1. Testen die op 23-10 slaagden en waar niets aan veranderd is, worden **niet** herhaald (A3–A8, U3, H5–H7, P1–P3, P5–P7, E5–E8, S1–S6, I1–I4, I6–I8).

## De tests, in volgorde (32 tests: de 31 uit het plan, met XSS als twee tests: met en zonder WAF)

### Fase 1 – ⏸ VPN als **tom**

1. **A2** (Tom doet dit): verbinding verbreken, opnieuw verbinden met code `000000`. Verwacht: `AUTH_FAILED`. Daarna weer verbinden met een geldige code. Laat Tom een screenshot maken (`A2-2710.png`).
2. **M2**: `az keyvault secret show --vault-name $KV --name jellyfin-admin-password --query value -o tsv | tr -d '\n' | wc -c` → `24`.
3. **M5**: laptop `nc -vz -G 5 192.168.4.6 8096` → timeout. Op mgmt: `timeout 5 bash -c "</dev/tcp/192.168.4.6/8096" && echo open || echo geblokkeerd` → `geblokkeerd`.
4. **I5**: op proxy `curl -s -o /dev/null -H 'X-Test: uid=0(root) gid=0(root)' http://example.com/`, wacht 30 seconden, dan op ids `sudo grep -i "id check" /var/log/suricata/fast.log | tail -3` → melding `GPL ATTACK_RESPONSE id check returned root` met tijdstempel van vandaag. Dit bewijst dat de nieuwe suppress-regel echte meldingen niet tegenhoudt.
5. **DVWA aanzetten**: in `ansible/host_vars/vm-web-01.yml` `web_dvwa_enabled: true`, commit (`test: enable DVWA for test round`), **vraag Tom om te pushen**, daarna op mgmt de play met `--limit webservers`. Verwacht `failed=0`.
6. **D1**: `az keyvault secret show --vault-name $KV --name dvwa-db-password --query value -o tsv | tr -d '\n' | wc -c` → 24, en `git grep -i "dvwa_db_password:"` → geen uitvoer.
7. **D2**: op web-01 `sudo stat -c "%a %U" /opt/zkoo/web/compose.yml` → `600 root`.

### Fase 2 – ⏸ VPN **uit** (Tom staat op het schoolnetwerk, IP 145.91.240.12)

8. **U1**: `curl -sk https://$P/ | grep Served` → `vm-web-02`.
9. **U2**: `curl -sk https://$P/portaal/ | grep Served` → `vm-web-01`.
10. **H1**: `curl -sk -o /dev/null -w "%{http_code}\n" "https://$P/portaal/?id=1'%20OR%20'1'='1"` → `403`.
11. **H2**: `curl -sk -o /dev/null -w "%{http_code}\n" "https://$P/?q=<script>alert(1)</script>"` → `403`.
12. **H3**: `curl -sk -o /dev/null -w "%{http_code}\n" "https://$P/portaal/?file=../../../../etc/passwd"` → `403`.
13. **H4**: `curl -sk -o /dev/null -w "%{http_code}\n" -A "sqlmap/1.7" https://$P/` → `403`.
14. **M4**: `curl -sk -o /dev/null -w "%{http_code} %{redirect_url}\n" https://$P/media` → `301` naar `/media/`.
15. **M6**: `curl -sk -o /dev/null -w "%{http_code}\n" "https://$P/media/?id=1'%20OR%20'1'='1"` → `403`.
16. **P4**: controleer eerst of `~/.ssh/zkoo_partner01` bestaat; zo niet, vraag Tom (de publieke sleutel staat in `ansible/files/sftp-keys/partner01.pub`, de privésleutel heeft Tom). Dan `echo "pwd" | sftp -P 2222 -i ~/.ssh/zkoo_partner01 -o StrictHostKeyChecking=accept-new partner01@$P` → `Connected`, `/`.
17. **U4** (Tom, browser): `https://20.160.79.1/` openen → pagina laadt na de certificaatwaarschuwing. Screenshot.
18. **D3** (Tom, browser): `https://20.160.79.1/portaal/dvwa/`, inloggen `admin` / `password`, *Create / Reset Database*, opnieuw inloggen, *DVWA Security* → *Low*. Verwacht: pagina's en links werken. Let op: blokkeert de WAF hier al iets (403 bij inloggen of setup)? Dan is dat een bevinding.
19. **D4** (Tom, browser): *SQL Injection*, invoer `1' OR '1'='1` → `403 Forbidden`. Screenshot.
20. **D4-XSS** (Tom, browser, nieuwe test): *XSS (Reflected)*, invoer `<script>alert('xss')</script>` → `403 Forbidden`. Screenshot.
21. **M3** (Tom, browser): `https://20.160.79.1/media/`, inloggen als `zkoo-admin` (wachtwoord: `az keyvault secret show --vault-name $KV --name jellyfin-admin-password --query value -o tsv`, alleen aan Tom tonen, niet opslaan) → startpagina met bibliotheek *Training*. Screenshot.

### Fase 3 – ⏸ VPN als **tom**

22. **H8**: op proxy `sudo docker logs proxy-waf-1 --since 2h 2>&1 | grep -ci modsecurity` → groter dan 0.
23. **I9**: op ids `sudo grep -c 168.63.129.16 /var/log/suricata/fast.log` → `0`, terwijl `sudo wc -l /var/log/suricata/fast.log` groter dan 0 is.
24. **M7**: een klein testvideobestand (vraag Tom welk bestand) via mgmt naar vm-media-01 kopiëren:
    `scp -i ~/.ssh/id_rsa -J azureadmin@192.168.13.4 <bestand> azureadmin@192.168.4.6:/tmp/` en op media `sudo mv /tmp/<bestand> /opt/zkoo/media/library/ && sudo chown 8096:8096 /opt/zkoo/media/library/<bestand>`. Daarna Tom: in Jellyfin *Dashboard → Libraries → Scan All Libraries*, video afspelen via `/media/`. Screenshot.
25. **D5**: start de tunnel op de achtergrond: `ssh -i ~/.ssh/id_rsa -f -N -J azureadmin@192.168.13.4 -L 8444:127.0.0.1:443 azureadmin@192.168.4.4`. Controleer met `curl -sk -o /dev/null -w "%{http_code}\n" https://localhost:8444/dvwa/login.php` → `200`. Tom opent `https://localhost:8444/dvwa/`, logt in en zet security weer op *Low*.
26. **D6** (Tom, browser): *SQL Injection*, `1' OR '1'='1` → lijst met alle gebruikers (de aanval lukt zonder WAF). Screenshot.
27. **D6-XSS** (Tom, browser, nieuwe test): *XSS (Reflected)*, `<script>alert('xss')</script>` → er verschijnt een alert-venster. Screenshot.
28. **D7**: tunnel stoppen (`pkill -f "8444:127.0.0.1:443"`), `web_dvwa_enabled: false`, commit (`test: disable DVWA after test round`), **vraag Tom om te pushen**, op mgmt de play met `--limit webservers`, dan `curl -sk -o /dev/null -w "%{http_code}\n" https://$P/portaal/dvwa/` → `404`.

### Fase 4 – ⏸ VPN als **medewerker01**

29. **E1b** (Tom): verbinden als medewerker01 met code `000000` → `AUTH_FAILED`. Screenshot.
30. **E1** (Tom): verbinden met een geldige code. Jij controleert `ifconfig | grep "inet 10.8"` → `10.8.0.x`.
31. **E2**: `curl -sk https://192.168.8.4/ | grep -i served` → `vm-app-01`.
32. **E3 en E4** (fileshare; dit telt als twee tests):
    - Wachtwoord ophalen zonder het te tonen of op te slaan: `SMBPW=$(az keyvault secret show --vault-name $KV --name smb-password-medewerker01 --query value -o tsv)`.
    - Mounten: `mkdir -p /tmp/zkoo-share && mount_smbfs "//medewerker01:${SMBPW}@192.168.8.5/zkoo-data" /tmp/zkoo-share && echo E3-ok` (lukt dat niet, laat Tom het via Finder doen).
    - Schrijven: `echo "test 27-10" > /tmp/zkoo-share/test-2710.txt && ls -l /tmp/zkoo-share`.
    - Opruimen: `umount /tmp/zkoo-share && unset SMBPW`.

## Afronding

1. Werk `docs/testplan.md` bij:
   - zet in de kop: datum 27-10-2026, uitgevoerd door Tom (met Claude Code);
   - zet bij elke geslaagde test ✓, en ✗ bij een mislukte;
   - voeg in sectie 4b twee regels toe voor de XSS-tests (D4-XSS en D6-XSS), in dezelfde opmaak;
   - voeg onder de tabellen deze zin toe: "Tests zonder wijziging in de betreffende configuratie zijn op 27-10-2026 niet herhaald; hun resultaat is van 23-10-2026.";
   - zet afwijkingen en opvallende dingen in de tabel *Bevindingen* (test-ID, wat, oorzaak, oplossing/conclusie).
2. Werk in Obsidian `ZKOO - Testplan en resultaten` bij (de status per blok en de bevindingen), en vink in `ZKOO - TODO` de afgeronde tests af.
3. Commit (`test: second test round 27-10-2026`) en vraag Tom om te pushen.
4. Geef Tom een korte samenvatting: hoeveel tests geslaagd, welke niet, welke bevindingen.

**Laat F1 (het IP van Tom weghalen) en F4 (`terraform destroy`) liggen: dat beslist Tom zelf.**
