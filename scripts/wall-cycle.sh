#!/usr/bin/env bash
# Slay the Princess Wallpaper Cycler for slaytheland
REAL_SCRIPT="$(readlink -f "${BASH_SOURCE[0]}")"
DIR="$(cd "$(dirname "$REAL_SCRIPT")/.." && pwd)"
WALL_DIR="$DIR/assets/wallpapers"
BG_DIR="$DIR/assets/backgrounds"
DEFAULT_WALL="$DIR/assets/backgrounds/ch1/cabin exterior/bg cabin p.png"
CACHE_FILE="$HOME/.cache/slaytheland_wall"

mkdir -p "$HOME/.cache"

# If a specific image argument is provided, use it
if [ $# -ge 1 ] && [ -f "$1" ]; then
    TARGET="$1"
else
    # Pick a random high-res CG wallpaper or background
    TARGET=$(find "$WALL_DIR" "$BG_DIR" -type f \( -name "*.jpg" -o -name "*.png" \) 2>/dev/null | shuf -n 1)
fi

if [ -z "${TARGET:-}" ] || [ ! -f "$TARGET" ]; then
    TARGET="$DEFAULT_WALL"
fi

echo "Setting wallpaper: $TARGET"
echo "$TARGET" > "$CACHE_FILE"

# Smoothly switch wallpaper with swaybg
pkill -x swaybg 2>/dev/null || true
swaybg -m fill -i "$TARGET" &
