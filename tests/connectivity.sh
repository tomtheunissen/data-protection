#!/usr/bin/env bash
# Connectivity tests for the ZKOO PoC. Run on vm-mgmt-01 (the only host that can SSH to every VM).
#
#   bash tests/connectivity.sh matrix   # N1: east-west segmentation matrix, compared with the design
#   bash tests/connectivity.sh egress   # N2: can each VM reach the internet?
#   bash tests/connectivity.sh dns      # N3: do PaaS names resolve to the private endpoints on each VM?
#   bash tests/connectivity.sh all      # all three
#
# Exit code 1 when a matrix probe differs from the design. Nothing on the VMs is changed.
set -u

TIMEOUT="${TIMEOUT:-3}"
SSH_OPTS=(-o BatchMode=yes -o ConnectTimeout=5 -o StrictHostKeyChecking=accept-new -o LogLevel=ERROR)

# Addresses; keep in sync with terraform/locals.tf
declare -A IP=(
  [vm-proxy-01]=192.168.1.4   [vm-vpn-01]=192.168.1.5
  [vm-web-01]=192.168.4.4     [vm-web-02]=192.168.4.5
  [vm-media-01]=192.168.4.6   [vm-ftp-01]=192.168.4.7
  [vm-app-01]=192.168.8.4     [vm-fs-01]=192.168.8.5
  [vm-mgmt-01]=192.168.13.4   [vm-ids-01]=192.168.13.5
  [pep-sensitivedata]=192.168.14.4 [pep-sql]=192.168.14.5 [pep-webapp]=192.168.14.6
)

SOURCES=(vm-proxy-01 vm-vpn-01 vm-web-01 vm-web-02 vm-media-01 vm-ftp-01 vm-app-01 vm-fs-01 vm-mgmt-01 vm-ids-01)

# Every service port of every VM and private endpoint (TCP only; the VXLAN mirror on 4789/udp is test I8)
TARGETS=(
  "vm-proxy-01 22" "vm-proxy-01 443" "vm-proxy-01 2222"
  "vm-vpn-01 22"
  "vm-web-01 22" "vm-web-01 443"
  "vm-web-02 22" "vm-web-02 443"
  "vm-media-01 22" "vm-media-01 8096"
  "vm-ftp-01 22"
  "vm-app-01 22" "vm-app-01 443"
  "vm-fs-01 22" "vm-fs-01 445"
  "vm-mgmt-01 22"
  "vm-ids-01 22"
  "pep-sensitivedata 445" "pep-sql 1433" "pep-webapp 443"
)

# Flows the design allows between Azure hosts (NSG + ufw). Everything else must be blocked.
# VPN clients (10.8.x.x) and internet sources are covered by the route tests (A, E, U, H, P).
ALLOWED=(
  "vm-mgmt-01>vm-proxy-01:22" "vm-mgmt-01>vm-vpn-01:22" "vm-mgmt-01>vm-web-01:22" "vm-mgmt-01>vm-web-02:22"
  "vm-mgmt-01>vm-media-01:22" "vm-mgmt-01>vm-ftp-01:22" "vm-mgmt-01>vm-app-01:22" "vm-mgmt-01>vm-fs-01:22"
  "vm-mgmt-01>vm-ids-01:22"
  "vm-proxy-01>vm-web-01:443" "vm-proxy-01>vm-web-02:443" "vm-proxy-01>vm-media-01:8096"
  "vm-proxy-01>vm-ftp-01:22" "vm-proxy-01>pep-webapp:443"
  "vm-web-01>pep-sensitivedata:445" "vm-web-01>pep-sql:1433"
)

is_allowed() {
  local key="$1>$2:$3" a
  for a in "${ALLOWED[@]}"; do [ "$a" = "$key" ] && return 0; done
  return 1
}

# Probe script that runs on a source VM: one line per target, "name port open|refused|timeout"
probe_script() {
  local src="$1" t name port
  echo "T=$TIMEOUT"
  for t in "${TARGETS[@]}"; do
    read -r name port <<< "$t"
    [ "$name" = "$src" ] && continue
    printf '( if timeout "$T" bash -c "</dev/tcp/%s/%s" 2>/dev/null; then r=open; elif [ $? -eq 124 ]; then r=timeout; else r=refused; fi; echo "%s %s $r" ) &\n' \
      "${IP[$name]}" "$port" "$name" "$port"
  done
  echo "wait"
}

run_on() {
  local src="$1"
  if [ "$src" = "vm-mgmt-01" ]; then
    bash -s
  else
    ssh "${SSH_OPTS[@]}" "${IP[$src]}" 'bash -s'
  fi
}

matrix() {
  local tmp src dst port result expected verdict pass fail
  tmp=$(mktemp -d)
  echo "== N1 segmentation matrix $(date '+%F %T') (timeout ${TIMEOUT}s) =="
  for src in "${SOURCES[@]}"; do
    probe_script "$src" | run_on "$src" > "$tmp/$src" 2> "$tmp/$src.err" &
  done
  wait
  printf '%-12s %-18s %-5s %-8s %-8s %s\n' SOURCE TARGET PORT EXPECTED RESULT VERDICT
  for src in "${SOURCES[@]}"; do
    if [ ! -s "$tmp/$src" ]; then
      # Counted as a failure below; the reason goes to stderr
      printf '%-12s %-18s %-5s %-8s %-8s %s\n' "${src#vm-}" "(all)" "-" "-" "no-ssh" FAIL
      echo "$src: SSH failed: $(tr '\n' ' ' < "$tmp/$src.err")" >&2
      continue
    fi
    sort "$tmp/$src" | while read -r dst port result; do
      if is_allowed "$src" "$dst" "$port"; then expected=open; else expected=blocked; fi
      # open = reachable; refused = network path open but no listener; timeout = dropped by NSG/ufw
      if { [ "$expected" = open ] && [ "$result" = open ]; } || { [ "$expected" = blocked ] && [ "$result" = timeout ]; }; then
        verdict=PASS
      else
        verdict=FAIL
      fi
      printf '%-12s %-18s %-5s %-8s %-8s %s\n' "${src#vm-}" "${dst#vm-}" "$port" "$expected" "$result" "$verdict"
    done
  done | tee "$tmp/table"
  pass=$(grep -c ' PASS$' "$tmp/table")
  fail=$(grep -c ' FAIL$' "$tmp/table")
  echo "== N1 result: $pass PASS, $fail FAIL (allowed flows in the design: ${#ALLOWED[@]}) =="
  rm -rf "$tmp"
  [ "$fail" -eq 0 ]
}

egress() {
  local src code
  echo "== N2 egress to the internet $(date '+%F %T') =="
  for src in "${SOURCES[@]}"; do
    code=$(echo 'curl -s -o /dev/null -w "%{http_code}" --max-time 8 https://www.example.com || echo "no-connection"' | run_on "$src" 2>/dev/null)
    printf '%-12s https://www.example.com -> %s\n' "${src#vm-}" "${code:-ssh-failed}"
  done
}

dns() {
  local src
  echo "== N3 private DNS from every VM $(date '+%F %T') =="
  echo "expected: sql-zkoo-01 -> 192.168.14.5, stzkoosensitive01 -> 192.168.14.4, app-zkoo-02 -> 192.168.14.6"
  for src in "${SOURCES[@]}"; do
    printf '%-12s ' "${src#vm-}"
    echo 'for n in sql-zkoo-01.database.windows.net stzkoosensitive01.file.core.windows.net app-zkoo-02.azurewebsites.net; do printf "%s=%s  " "${n%%.*}" "$(getent hosts "$n" | awk "{print \$1}" | head -1)"; done; echo' \
      | run_on "$src" 2>/dev/null || echo "ssh-failed"
  done
}

case "${1:-all}" in
  matrix) matrix ;;
  egress) egress ;;
  dns) dns ;;
  all) rc=0; matrix || rc=1; echo; egress; echo; dns; exit "$rc" ;;
  *) echo "usage: $0 [matrix|egress|dns|all]" >&2; exit 2 ;;
esac
