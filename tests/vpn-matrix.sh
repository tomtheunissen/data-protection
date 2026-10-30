#!/usr/bin/env bash
# Segmentation matrix seen from a VPN client (run on the laptop while connected to the VPN).
# Detects the pool from the laptop's VPN address and compares every probe with what the design allows:
#   admin pool    (10.8.4.0/24): only the jump host (vm-mgmt-01:22)
#   employee pool (10.8.0.0/22): only vm-app-01:443, vm-fs-01:445 and Azure Files (pep-sensitivedata:445)
# Written for the bash 3.2 that ships with macOS (no associative arrays). Exit code 1 on any FAIL.
set -u

TIMEOUT="${TIMEOUT:-3}"

# "name ip port" for every service port in the VNet (same targets as connectivity.sh matrix)
TARGETS=(
  "vm-proxy-01 192.168.1.4 22" "vm-proxy-01 192.168.1.4 443" "vm-proxy-01 192.168.1.4 2222"
  "vm-vpn-01 192.168.1.5 22"
  "vm-web-01 192.168.4.4 22" "vm-web-01 192.168.4.4 443"
  "vm-web-02 192.168.4.5 22" "vm-web-02 192.168.4.5 443"
  "vm-media-01 192.168.4.6 22" "vm-media-01 192.168.4.6 8096"
  "vm-ftp-01 192.168.4.7 22"
  "vm-app-01 192.168.8.4 22" "vm-app-01 192.168.8.4 443"
  "vm-fs-01 192.168.8.5 22" "vm-fs-01 192.168.8.5 445"
  "vm-mgmt-01 192.168.13.4 22"
  "vm-ids-01 192.168.13.5 22"
  "pep-sensitivedata 192.168.14.4 445" "pep-sql 192.168.14.5 1433" "pep-webapp 192.168.14.6 443"
)

addr=$(ifconfig | awk '/inet 10\.8\./ {print $2; exit}')
case "$addr" in
  10.8.4.*) pool="admin";    ALLOWED="vm-mgmt-01:22" ;;
  10.8.[0-3].*) pool="employee"; ALLOWED="vm-app-01:443 vm-fs-01:445 pep-sensitivedata:445" ;;
  *) echo "Not connected to the VPN (no 10.8.x.x address found)" >&2; exit 2 ;;
esac

tmp=$(mktemp -d)
echo "== VPN matrix, pool $pool ($addr), $(date '+%F %T'), timeout ${TIMEOUT}s =="

i=0
for t in "${TARGETS[@]}"; do
  set -- $t
  # nc prints "succeeded", "Connection refused" or "Operation timed out" on stderr
  ( out=$(nc -z -G "$TIMEOUT" -w "$TIMEOUT" "$2" "$3" 2>&1)
    case "$out" in
      *succeeded*) r=open ;;
      *refused*) r=refused ;;
      *) r=timeout ;;
    esac
    echo "$1 $3 $r" > "$tmp/$i" ) &
  i=$((i + 1))
done
wait

printf '%-18s %-5s %-8s %-8s %s\n' TARGET PORT EXPECTED RESULT VERDICT
pass=0; fail=0
for f in $(ls "$tmp" | sort -n); do
  read -r name port result < "$tmp/$f"
  case " $ALLOWED " in
    *" $name:$port "*) expected=open ;;
    *) expected=blocked ;;
  esac
  if { [ "$expected" = open ] && [ "$result" = open ]; } || { [ "$expected" = blocked ] && [ "$result" = timeout ]; }; then
    verdict=PASS; pass=$((pass + 1))
  else
    verdict=FAIL; fail=$((fail + 1))
  fi
  printf '%-18s %-5s %-8s %-8s %s\n' "${name#vm-}" "$port" "$expected" "$result" "$verdict"
done
echo "== VPN matrix ($pool): $pass PASS, $fail FAIL =="
rm -rf "$tmp"
[ "$fail" -eq 0 ]
