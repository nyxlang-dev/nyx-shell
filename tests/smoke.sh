#!/bin/bash
# smoke.sh — smoke test de nyx-shell. El shell usa raw-mode/isatty, así que
# se maneja bajo un PTY con `script -qec` (util-linux, presente en Debian).
set -e
STACK="$(cd "$(dirname "$0")/.." && pwd)"
BIN="${NYX_SHELL_BIN:-$STACK/nyx-shell}"
[ -x "$BIN" ] || { echo "SKIP: $BIN not built (make build)"; exit 0; }

out=$(printf 'echo smoke-ok\nexit\n' | script -qec "$BIN" /dev/null 2>&1) || true
echo "$out" | grep -q "smoke-ok" || { echo "FAIL: builtin echo"; echo "--- output ---"; echo "$out" | head -10; exit 1; }

out2=$(printf '/bin/echo external-ok\nexit\n' | script -qec "$BIN" /dev/null 2>&1) || true
echo "$out2" | grep -q "external-ok" || { echo "FAIL: exec externo"; echo "--- output ---"; echo "$out2" | head -10; exit 1; }

echo "smoke: 2/2 PASS"
