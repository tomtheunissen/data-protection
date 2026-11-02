# OWASP ZAP-scan ZKOO-PoC – 02-11-2026

Uitrol van 02-11-2026 (`kv-zkoo-9440`, proxy 20.8.94.69, VPN 20.160.201.50). Uitgevoerd door Tom met Claude Code. Tijden in UTC, details in `tijden.txt`.

- **ZAP:** 2.17.0 (`ghcr.io/zaproxy/zaproxy:stable`)
- **Z1–Z3:** `zap-baseline.py` (passief) vanaf de laptop, via de WAF
- **Z4/Z5:** Automation Framework-plan, ingelogde actieve scan van DVWA (security *Low*). Z4 en Z5 gebruiken **hetzelfde plan**; alleen het doel verschilt:
  - Z4 via de WAF: `https://20.8.94.69/portaal/dvwa/` (vanaf de laptop)
  - Z5 zonder WAF: `https://192.168.4.4/dvwa/` (ZAP-container op vm-proxy-01, de enige host die web-01:443 mag bereiken)

## Scaninstellingen Z4 en Z5

| | Z4 (via WAF) | Z5 (zonder WAF) |
|---|---|---|
| Scope | `…/dvwa/.*` (alle DVWA-pagina's) | idem |
| Uitgesloten | `logout.php`, `setup.php`, `security.php`, `login.php`, `vulnerabilities/csrf`, `vulnerabilities/captcha` | idem |
| Sessie | `PHPSESSID` + `security=low` via replacer-regel | idem, met een verse sessie na *Create / Reset Database* (Z4 had het gastenboek vervuild) |
| User-Agent | Chrome 141 via replacer-regel (zie Z4a) | idem |
| Spider / actieve scan | max. 3 min / max. 14 min, max. 2 min per regel | idem |
| Java-heap | `-Xmx979m` (standaard: 1/4 van de 3916 MB van de Docker-VM op de laptop) | `-Xmx976m` (standaard: 1/4 van de 3906 MB van vm-proxy-01), container `--memory 1500m`. Geen OOM, dus geen herkansing met `-Xmx768m` en smallere scope nodig |
| Spider vond | 125 URL's | 258 URL's |
| Actieve scan | 6 min 59 s, **zelf afgerond** | 14 min 06 s, **afgebroken op de tijdslimiet** (niet alle regels afgerond) |

## Meldingen per scan

| ID | Doel | High | Medium | Low | Info | Belangrijkste meldingen |
|---|---|---|---|---|---|---|
| Z1 | `/` (web-02) | 0 | 2 | 6 | 3 | Ontbrekende CSP en anti-clickjacking, geen HSTS, X-Content-Type-Options, Permissions-Policy |
| Z2 | `/app/` (app-zkoo-02) | 0 | 3 | 7 | 3 | Idem, plus externe JavaScript zonder SRI (standaardpagina App Service) |
| Z3 | `/media/` (Jellyfin) | 0 | 2 | 6 | 5 | Idem, plus *Modern Web Application*: de spider kan de JavaScript-app niet doorlopen |
| Z4 | DVWA via de WAF | 3 | 7 | 8 | 8 | DOM-XSS, open redirect, SQLi op `btnSign` (zie hieronder) |
| Z5 | DVWA zonder WAF | 9 | 7 | 10 | 6 | Reflected XSS, SQLi (sqli, sqli_blind, brute), OS command injection, path traversal, remote file inclusion, open redirect |

Z1–Z3 hebben alleen meldingen die horen bij **ontbrekende security headers**: dezelfde set op alle drie de routes, omdat ze uit de WAF komen. Dat sluit aan bij afwijking #3 (security headers uit het Securityplan nog niet gebouwd).

## Vergelijking Z4 (via WAF) ↔ Z5 (zonder WAF), hoge risico's

| Melding | Z4 via WAF | Z5 zonder WAF |
|---|---|---|
| SQL Injection (MySQL) – `sqli`, `brute` | – | ✔ |
| SQL Injection – `sqli_blind`, `xss_s` | `xss_s` (`btnSign`, vals-positief) | ✔ |
| Cross Site Scripting (Reflected) – `xss_r`, `xss_s`, `csp` | – | ✔ |
| Remote OS Command Injection (ook time-based) – `exec`, `csp`, `upload` | – | ✔ |
| Path Traversal / Remote File Inclusion – `fi` | – | ✔ |
| PHP Version with Known Vulnerabilities | – | ✔ (`X-Powered-By: PHP/8.5.11` rechtstreeks van web-01; via de WAF verborgen, H9) |
| External Redirect – `open_redirect` | ✔ | ✔ |
| Cross Site Scripting (DOM Based) – `xss_d` | ✔ | – (zie noot) |

De drie hoge meldingen die door de WAF heen kwamen (Z4):

- **DOM-XSS (`xss_d`):** de payload staat in het fragment na `#`. Dat bereikt de server nooit, dus geen enkele WAF ziet het. Dit is een principiële grens van een WAF; de oplossing ligt in de code (geen onveilige DOM-sinks) en in een strikte CSP.
- **Open redirect (`open_redirect`):** echt. De parameter `redirect=https://…` is voor de WAF een geldige URL.
- **SQLi op `btnSign` (`xss_s`):** waarschijnlijk vals-positief (betrouwbaarheid Medium, er is geen data teruggekomen). In DVWA is `btnSign` alleen de verzendknop en wordt hij niet in een query gebruikt. Wel bevestigd: de WAF laat dit verzoek door. Na het uitzetten van DVWA gaf hetzelfde `POST` met `btnSign=Sign Guestbook OR 1=1 -- ` een **404** van de backend en geen 403 (`Z4-sqli-btnsign-check.txt`). Zo'n zwak patroon blijft onder de drempel van de CRS (anomaly score < 5 op paranoia-niveau 1).

**Noot bij DOM-XSS in Z5:** Z5 is op de tijdslimiet van 14 minuten afgebroken, omdat hij twee keer zoveel URL's had en de backend elke aanval beantwoordde. De DOM-XSS-regel is daardoor waarschijnlijk niet meer aan de beurt gekomen. Dat de kwetsbaarheid zonder WAF bestaat, volgt uit Z4: de WAF ziet het fragment toch nooit.

**Conclusie:** de applicatie zelf is zwaar kwetsbaar (Z5: 9 hoge risico's, waaronder SQLi, XSS, command injection en file inclusion). Via de WAF blijven er 3 over, en geen enkele daarvan is een server-side injectie die de CRS had moeten tegenhouden: DOM-XSS is voor een WAF onzichtbaar, de open redirect is een geldige URL, en de SQLi is vals-positief. De WAF maakt dus het verschil voor de server-side aanvallen, maar vervangt geen veilige code. Dat bevestigt D4–D6 met een geautomatiseerde scanner.

## Z4a – lege User-Agent geblokkeerd door de WAF

De spider van het Automation Framework stuurt in deze ZAP-versie een **lege** `User-Agent:`-header. De WAF blokkeert die met 403 (anomaly score 5, regel 949110). De onderliggende regel is waarschijnlijk CRS 920330 *Empty User Agent Header*; dat is niet bewezen, omdat de WAF-log alleen 949110 vastlegt (bevinding D4). Gevolg zonder maatregel: de spider vond 2 in plaats van 125 URL's. Bewijs in `Z4-useragent-test.txt`, met geldige sessie:

| Verzoek | Status | nginx-log |
|---|---|---|
| User-Agent-header ontbreekt (`curl -A ""`) | 200 | `"-"` |
| User-Agent-header aanwezig maar leeg (`-H "User-Agent;"`) | **403** | `""` |
| Chrome-User-Agent | 200 | `"Mozilla/5.0 …"` |

Hetzelfde gebeurde bij de baselinescans: de spiderverzoeken van Z1–Z3 naar `/`, `robots.txt`, `sitemap.xml`, `/app/` en `/media/` kregen 403 (`Z6-waf-403.txt`). Hun passieve meldingen komen van het eerste verzoek van ZAP, dat wél een browser-User-Agent heeft. De dekking van Z1–Z3 is daardoor beperkt tot de startpagina's. Voor Z4/Z5 zet een replacer-regel een Chrome-User-Agent, zoals een echte aanvaller ook zou doen.

## Z1b–Z3b – baselinescans opnieuw, met browser-User-Agent

Om de beperking van Z1–Z3 op te heffen, zijn de drie baselinescans om 17:48–17:49 UTC opnieuw gedraaid met dezelfde User-Agent-replacer. `zap-baseline.py` accepteert de replacer alleen via `-z`, dat op spaties splitst, en een browser-User-Agent bevat spaties. Daarom is een gelijkwaardig AF-plan gebruikt: replacer, spider max. 1 min, passieve scan, rapporten (`Z1b-plan.yaml` … `Z3b-plan.yaml`). De originelen Z1–Z3 blijven ernaast staan.

| ID | Doel | URL's (Z1–Z3 → b) | High | Medium | Low | Info | Opvallend |
|---|---|---|---|---|---|---|---|
| Z1b | `/` | 4 → 3 | 0 | 2 | 2 | 1 | Dezelfde header-meldingen |
| Z2b | `/app/` | 6 → 9 | 0 | 3 | 3 | 1 | Dezelfde header-meldingen |
| Z3b | `/media/` | 6 → **58** | 0 | 1 | 4 | 3 | Nieuw: *Private IP Disclosure*, *Timestamp Disclosure*, *Information Disclosure – Suspicious Comments* (Jellyfin-JavaScript) |

- Vooral Jellyfin profiteert: de spider komt nu bij de scripts en API-paden.
- Ook met volledige dekking komt er **geen High** bij. De conclusie van Z1–Z3 blijft dus staan: alleen ontbrekende security headers.
- **Let op bij vergelijken:** het AF-plan gebruikt de standaardset passieve regels; `zap-baseline.py` zet er meer aan. Daarom ontbreken in Z1b–Z3b meldingen als COEP/COOP/CORP, Permissions-Policy en de cache-meldingen. Die zijn niet opgelost, ze zijn niet gecontroleerd. De aantallen per risico zijn dus niet één-op-één vergelijkbaar; voor de headers gelden Z1–Z3, voor de dekking Z1b–Z3b.

## Z6 – wat zagen de WAF en de IDS?

**WAF** (`Z6-waf-403.txt`, sinds 15:58:46):

- Z4-venster: **3707 van de 8253 verzoeken geblokkeerd (45 %)**. Verder 2371× 200, 1310× 301, 411× 404, 365× 500.
- Meest geblokkeerde pagina's: `xss_s` (772), `javascript` (396), `brute` (395), `sqli_blind` (274), `exec` (272), `sqli` (266).
- Anomaly scores van de blokkades: vooral 8, 13 en 18, met uitschieters tot 83. Alleen regel 949110 wordt gelogd (D4).

**IDS** (`Z6-ids-meldingen.txt`, 14 043 nieuwe regels sinds de nulmeting van 17):

- Vrijwel alles is `SURICATA STREAM`-protocolanomalie (onder andere `3way handshake wrong seq wrong ack`) op de proxy ↔ web-01/web-02 en de laptop ↔ proxy, plus ruis van ghcr.io (het image downloaden voor Z5) en van 169.254.169.254.
- **169.254.169.254 is de Azure Instance Metadata Service (IMDS).** Die geeft ruis: 85 + 73 keer `SURICATA HTTP unable to match response to request` en ruim 30 `STREAM`-meldingen op vpn en proxy. Het is hetzelfde soort platformverkeer als WireServer (168.63.129.16), dat al met een suppress-regel in `threshold.config` is onderdrukt (I9). IMDS kan op dezelfde manier worden onderdrukt. Alleen genoteerd, niet aangepast.
- **Geen enkele SQLi-, XSS- of webaanval-signature.** De IDS ziet alleen versleuteld verkeer: internet → WAF is HTTPS, en de WAF → backends ook. De 2 ET-meldingen zijn reputatiehits (`ET CINS Poor Reputation IP`) van willekeurige internetscanners.
- Conclusie: de IDS laat de omvang van de scan zien (het volume aan anomalieën), maar niet de inhoud. Voor detectie op applicatieniveau moet de IDS het verkeer na TLS-terminatie zien, of moeten de WAF-logs naar de SIEM.

## Bevindingen uit deze ronde

| ID | Bevinding |
|---|---|
| T1.2 | Eerste `terraform apply` brak af door een netwerkfout bij het wegschrijven van de remote state; plan (0 destroy) en tweede apply losten het op |
| Z4a | Lege User-Agent (AF-spider) geblokkeerd door de WAF; dekking Z1–Z3 beperkt, opnieuw gedaan als Z1b–Z3b |
| Z4 | Via de WAF: DOM-XSS (principiële grens), open redirect, SQLi-vals-positief dat de WAF wel doorlaat |
| Z6 | IDS ziet geen webaanvallen in HTTPS-verkeer, alleen stream-anomalieën; de Azure Instance Metadata Service (169.254.169.254) geeft ruis en kan net als WireServer (I9) met een suppress-regel worden onderdrukt |
| 8c | `-e web_dvwa_enabled=true` met `--limit webservers` faalde op web-02 (variabele alleen in `host_vars` van web-01, `no_log` verbergt de fout); oplossing `--limit vm-web-01` |
| V3 | VPN-sessie viel na ~57 min weg door de standaard TLS-renegotiation; met TOTP kan de client niet opnieuw inloggen. Advies: `auth-gen-token` |
