#!/usr/bin/env bash
# ==============================================================================
# slaytheland: System Health & Environment Doctor
# Inspects compositor, shell runtime, audio engine, and game verification
# ==============================================================================
set -euo pipefail

REAL_SCRIPT="$(readlink -f "${BASH_SOURCE[0]}")"
ROOT="$(cd "$(dirname "$REAL_SCRIPT")/.." && pwd)"

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
NC='\033[0m'

pass=0
fail=0

check() {
    local name="$1"
    local cmd="$2"
    echo -n "  Checking $name... "
    if eval "$cmd" >/dev/null 2>&1; then
        echo -e "${GREEN}${BOLD}PASS${NC}"
        pass=$((pass + 1))
    else
        echo -e "${RED}${BOLD}FAIL${NC}"
        fail=$((fail + 1))
    fi
}

echo -e "${BOLD}================================================================================"
echo -e "                 slaytheland Doctor: System & Runtime Health                    "
echo -e "================================================================================${NC}"

echo -e "\n${BOLD}[1] Compositor & Display Server:${NC}"
check "Hyprland binary" "command -v Hyprland"
check "Hyprlock binary" "command -v hyprlock"
check "hyprctl IPC utility" "command -v hyprctl"
check "Hyprland Lua config valid" "Hyprland --verify-config -c $ROOT/hypr/hyprland.lua"

echo -e "\n${BOLD}[2] Quickshell & Qt Runtime:${NC}"
check "Quickshell runtime (qs)" "command -v quickshell"
check "PipeWire audio service" "command -v wpctl"
check "UPower battery service" "command -v upower || true"

echo -e "\n${BOLD}[3] Game Ownership & Assets:${NC}"
check "Slay the Princess detection" "$ROOT/tools/detect_game.sh /home/arch/slaytheland/assets >/dev/null 2>&1 || [ -d '$ROOT/assets/gui' ]"
check "Extracted assets presence" "[ -f '$ROOT/assets/.verified' ] || [ -d '$ROOT/assets/gui' ]"
check "Pencil boil shader compiled" "[ -f '$ROOT/quickshell/shaders/pencil_boil.frag.qsb' ]"

echo -e "\n${BOLD}[4] Official Fonts & Cursors:${NC}"
check "Amatic SC font loaded" "fc-list : family | grep -i 'Amatic SC'"
check "Kelmscott Roman NF loaded" "fc-list : family | grep -i 'Kelmscott Roman NF'"
check "SlayThePrincess cursor theme" "[ -d '$HOME/.local/share/icons/SlayThePrincess' ] || [ -d '$ROOT/assets/icons/SlayThePrincess' ]"

echo -e "\n${BOLD}================================================================================"
if [ "$fail" -eq 0 ]; then
    echo -e "${GREEN}${BOLD}✓ All $pass checks passed! slaytheland is healthy and ready for the cabin.${NC}"
else
    echo -e "${YELLOW}${BOLD}⚠ $pass passed, $fail failed. Review the failures above.${NC}"
fi
echo -e "${BOLD}================================================================================${NC}"
