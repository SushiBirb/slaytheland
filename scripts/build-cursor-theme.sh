#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
GUI="$DIR/assets/gui"
THEME_DIR="$DIR/assets/icons/SlayThePrincess"
CURSORS_DIR="$THEME_DIR/cursors"

mkdir -p "$CURSORS_DIR"

cat << 'EOF' > "$THEME_DIR/index.theme"
[Icon Theme]
Name=SlayThePrincess
Comment=Hand-drawn pencil and blade cursor theme from Slay the Princess
Inherits=Adwaita
EOF

echo ">> Generating cursor theme..."

# Helper to generate an XCursor with symlinks
gen_cursor() {
    local src_png="$1"
    local hot_x="$2"
    local hot_y="$3"
    local primary_name="$4"
    shift 4
    local aliases=("$@")

    local cfg="/tmp/cursor_${primary_name}.cfg"
    echo "48 $hot_x $hot_y $src_png" > "$cfg"
    xcursorgen "$cfg" "$CURSORS_DIR/$primary_name"
    rm -f "$cfg"

    for alias in "${aliases[@]}"; do
        ln -sf "$primary_name" "$CURSORS_DIR/$alias"
    done
}

# 1. Default arrow / pointer (pencil pointer)
gen_cursor "$GUI/cursor1.png" 1 0 default \
    left_ptr arrow top_left_arrow right_ptr

# 2. Hand / link pointer (the pristine blade)
gen_cursor "$GUI/sword_cursor.png" 2 1 pointer \
    hand2 pointing_hand hand

# 3. Crosshair / precision (bloody blade)
gen_cursor "$GUI/cursor2_blood.png" 1 0 crosshair \
    cross cell draft_large draft_small

# 4. Wait / busy (the shifting eye)
gen_cursor "$GUI/eye_cursor.png" 24 24 wait \
    watch progress half-busy

echo ">> Cursor theme SlayThePrincess generated at $THEME_DIR"
