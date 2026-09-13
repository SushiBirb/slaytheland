#!/usr/bin/env bash
# ==============================================================================
# slaytheland: Steam / GOG Game Ownership & Installation Detector
# Verifies that "Slay the Princess" is legitimately installed on this machine.
# ==============================================================================
set -euo pipefail

APPID="1989270"
GAME_NAME="Slay the Princess"
CUSTOM_PATH="${1:-}"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
NC='\033[0m'

candidates=()

# 1. Custom path supplied as parameter
if [ -n "$CUSTOM_PATH" ]; then
    candidates+=("$CUSTOM_PATH" "$CUSTOM_PATH/game" "$CUSTOM_PATH/common/$GAME_NAME/game")
fi

# 2. Standard Steam locations
COMMON_STEAM_PATHS=(
    "$HOME/.local/share/Steam"
    "$HOME/.steam/steam"
    "$HOME/.steam/root"
    "$HOME/.var/app/com.valvesoftware.Steam/.local/share/Steam"
)

for sp in "${COMMON_STEAM_PATHS[@]}"; do
    if [ -d "$sp/steamapps" ]; then
        candidates+=("$sp/steamapps/common/$GAME_NAME/game")
        # Read secondary libraries from libraryfolders.vdf
        vdf="$sp/steamapps/libraryfolders.vdf"
        if [ -f "$vdf" ]; then
            while IFS= read -r line; do
                if [[ "$line" =~ \"path\"[[:space:]]*\"([^\"]+)\" ]]; then
                    lib_path="${BASH_REMATCH[1]}"
                    candidates+=("$lib_path/steamapps/common/$GAME_NAME/game")
                fi
            done < "$vdf"
        fi
    fi
done

# 3. Check GOG or standalone wine prefix paths
candidates+=(
    "$HOME/GOG Games/Slay the Princess/game"
    "$HOME/Games/slay-the-princess/game"
)

# Search candidates for archive.rpa
FOUND_GAME_DIR=""
for c in "${candidates[@]}"; do
    if [ -f "$c/archive.rpa" ]; then
        FOUND_GAME_DIR="$c"
        break
    fi
done

if [ -z "$FOUND_GAME_DIR" ]; then
    echo -e "${RED}${BOLD}================================================================================"
    echo -e "                   AUTHENTIC GAME INSTALLATION REQUIRED                         "
    echo -e "================================================================================${NC}"
    echo -e " slaytheland is an authentic visual-novel desktop shell designed specifically"
    echo -e " for owners of ${BOLD}\"Slay the Princess\"${NC} by Black Tabby Games."
    echo -e ""
    echo -e " In respect of the creators, this rice bundles ${BOLD}NO COPYRIGHTED GAME ASSETS${NC}."
    echo -e " All backgrounds, character sprites, fonts, music, and voice lines must be"
    echo -e " extracted locally from your legitimate game purchase."
    echo -e ""
    echo -e " ${YELLOW}Could not locate 'archive.rpa' in any Steam or GOG library.${NC}"
    echo -e ""
    echo -e " Support Black Tabby Games and purchase the game here:"
    echo -e "   • Steam: ${BOLD}https://store.steampowered.com/app/1989270/Slay_the_Princess/${NC}"
    echo -e "   • GOG:   ${BOLD}https://www.gog.com/en/game/slay_the_princess${NC}"
    echo -e ""
    echo -e " If you have already installed the game to a custom directory, run:"
    echo -e "   ${BOLD}./tools/detect_game.sh \"/path/to/Slay the Princess/game\"${NC}"
    echo -e "${RED}================================================================================${NC}"
    exit 1
fi

echo -e "${GREEN}${BOLD}✓ Valid game installation detected!${NC}"
echo -e "  Location: ${FOUND_GAME_DIR}"
echo -e "  Archive:  ${FOUND_GAME_DIR}/archive.rpa"

# Print location for caller scripts
echo "$FOUND_GAME_DIR" > /tmp/slaytheland_game_dir
exit 0
