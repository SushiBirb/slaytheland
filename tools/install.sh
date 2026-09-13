#!/usr/bin/env bash
# ==============================================================================
# slaytheland: Master Installer & Setup Script
# Verifies game ownership, extracts assets, and installs desktop configuration
# ==============================================================================
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CUSTOM_PATH="${1:-}"

echo "================================================================================"
echo "                   slaytheland: Slay the Princess Desktop Shell                 "
echo "================================================================================"

# Step 1: Detect game & extract assets
"$ROOT/tools/extract.sh" "$CUSTOM_PATH"

# Step 2: Install official typography fonts system-wide
echo ">> Installing Slay the Princess fonts to ~/.local/share/fonts/slaytheland/..."
FONT_DST="$HOME/.local/share/fonts/slaytheland"
mkdir -p "$FONT_DST"
if [ -d "$ROOT/assets/fonts" ]; then
    cp -f "$ROOT"/assets/fonts/*.ttf "$FONT_DST/" 2>/dev/null || true
    cp -f "$ROOT"/assets/fonts/*.otf "$FONT_DST/" 2>/dev/null || true
    fc-cache -f "$FONT_DST" >/dev/null 2>&1 || true
    echo "✓ Fonts installed & cached."
fi

# Step 3: Link quickshell config
echo ">> Linking Quickshell configuration..."
mkdir -p "$HOME/.config/quickshell"
ln -sfn "$ROOT/quickshell" "$HOME/.config/quickshell/slaytheland"
echo "✓ Quickshell linked: ~/.config/quickshell/slaytheland -> $ROOT/quickshell"

# Step 4: Link helper binaries to ~/.local/bin
echo ">> Linking helper binaries into ~/.local/bin..."
mkdir -p "$HOME/.local/bin"
ln -sfn "$ROOT/scripts/wall-cycle.sh" "$HOME/.local/bin/slay-wall-cycle"
ln -sfn "$ROOT/tools/doctor.sh" "$HOME/.local/bin/slay-doctor"
chmod +x "$ROOT/scripts/wall-cycle.sh" "$ROOT/tools/doctor.sh"
echo "✓ Helpers linked: slay-wall-cycle, slay-doctor"

# Step 5: Verification summary
echo "================================================================================"
echo "✓ Installation complete! slaytheland is ready."
echo "  To launch in Quickshell: qs -c slaytheland"
echo "  To test in the isolated VM sandbox: ./run.sh"
echo "================================================================================"
