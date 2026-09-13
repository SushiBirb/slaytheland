#!/usr/bin/env bash
# ==============================================================================
# slaytheland: Local Game Asset Extraction Pipeline
# Extracts official Slay the Princess assets into assets/
# ==============================================================================
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CUSTOM_ARG="${1:-}"
FORCE=0
CUSTOM_PATH=""

if [ "$CUSTOM_ARG" = "--force" ]; then
    FORCE=1
elif [ -n "$CUSTOM_ARG" ]; then
    CUSTOM_PATH="$CUSTOM_ARG"
fi

if { [ -f "$ROOT/assets/.verified" ] || [ -f "$ROOT/assets/gui/textbox.png" ]; } && [ "$FORCE" -eq 0 ] && [ -z "$CUSTOM_PATH" ]; then
    echo ">> Authentic assets already extracted and present in assets/."
    echo "   (Pass --force to re-extract from game archive)."
    exit 0
fi

# 1. Detect and verify authentic game installation
echo ">> 1. Verifying game installation..."
"$ROOT/tools/detect_game.sh" "$CUSTOM_PATH"
GAME_DIR="$(cat /tmp/slaytheland_game_dir)"

# 2. Run Python RPA unpacker
echo ">> 2. Extracting game archive from: $GAME_DIR..."
python3 - << PYEOF
import os, sys, zlib, pickle, shutil

GAME_DIR = "$GAME_DIR"
RPA_PATH = os.path.join(GAME_DIR, "archive.rpa")
DEST_DIR = "$ROOT/assets"

os.makedirs(DEST_DIR, exist_ok=True)

with open(RPA_PATH, "rb") as f:
    header = f.readline().decode("latin1").strip()
    parts = header.split()
    offset = int(parts[1], 16)
    key = int(parts[2], 16) if len(parts) > 2 else 0
    f.seek(offset)
    index = pickle.loads(zlib.decompress(f.read()))

def extract_file(src, dst):
    if src not in index:
        return False
    os.makedirs(os.path.dirname(dst), exist_ok=True)
    with open(RPA_PATH, "rb") as af, open(dst, "wb") as out:
        for chunk in index[src]:
            o, dlen, prefix = (chunk[0], chunk[1], b"") if len(chunk) == 2 else (chunk[0], chunk[1], chunk[2])
            af.seek(o ^ key)
            out.write(prefix)
            out.write(af.read(dlen ^ key))
    return True

# GUI elements
print("   -> Extracting GUI elements...")
for p in index:
    if p.startswith("gui/") and not p.startswith("gui/phone/"):
        extract_file(p, os.path.join(DEST_DIR, p))

# Background plates
print("   -> Extracting parallax background plates...")
for p in index:
    if p.startswith("images/_backgrounds/"):
        extract_file(p, os.path.join(DEST_DIR, p.replace("images/_backgrounds/", "backgrounds/")))

# CG Wallpapers
print("   -> Extracting CG wallpapers...")
for p in index:
    if p.startswith("images/_gallery/") and p.endswith((".jpg", ".png")) and "big" in p:
        extract_file(p, os.path.join(DEST_DIR, p.replace("images/_gallery/", "wallpapers/")))

# Character Sprites (Princess Vessels)
print("   -> Extracting transparent character sprites...")
sprite_mappings = {
    "images/_sprites/ch1/princess distant/princess d neutral p.png": "sprites/ch1/princess_idle.png",
    "images/_sprites/ch1/princess distant/princess d questioning talk p.png": "sprites/ch1/princess_talk.png",
    "images/_sprites/ch1/princess distant/princess d down p.png": "sprites/ch1/princess_thinking.png",
    "images/_sprites/ch1/princess distant/princess d haughty p.png": "sprites/ch1/princess_haughty.png",
    "images/_sprites/ch2/damsel/damsel close stare p.png": "sprites/ch2/damsel_idle.png",
    "images/_sprites/ch2/damsel/damsel close talk p.png": "sprites/ch2/damsel_talk.png",
    "images/_sprites/ch2/witch/witch free crawl p.png": "sprites/ch2/witch_idle.png",
    "images/_sprites/ch2/nightmare/nightmare neutral p.png": "sprites/ch2/nightmare_idle.png",
    "images/_sprites/ch2/tower/tower neutral p.png": "sprites/ch2/tower_idle.png",
    "images/_sprites/ch2/razor/razor neutral p.png": "sprites/ch2/razor_idle.png",
    "images/_sprites/ch2/adversary/adversary neutral p.png": "sprites/ch2/adversary_idle.png",
    "images/_sprites/ch2/spectre/spectre neutral p.png": "sprites/ch2/spectre_idle.png",
    "images/_sprites/ch2/spectre/spectre talk p.png": "sprites/ch2/spectre_talk.png",
    "images/_sprites/ch2/prisoner/prisoner neutral p.png": "sprites/ch2/prisoner_idle.png",
    "images/_sprites/ch2/prisoner/prisoner talk p.png": "sprites/ch2/prisoner_talk.png",
    "images/_sprites/ch2/beast/beast neutral p.png": "sprites/ch2/beast_idle.png",
    "images/_sprites/ch2/stranger/stranger neutral p.png": "sprites/ch2/stranger_idle.png"
}
for src, dst in sprite_mappings.items():
    extract_file(src, os.path.join(DEST_DIR, dst))

# Fonts
print("   -> Copying game typography fonts...")
fonts_dir = os.path.join(GAME_DIR, "gui", "fonts")
dst_fonts = os.path.join(DEST_DIR, "fonts")
os.makedirs(dst_fonts, exist_ok=True)
if os.path.exists(fonts_dir):
    for f in os.listdir(fonts_dir):
        if f.endswith((".ttf", ".otf")):
            shutil.copy2(os.path.join(fonts_dir, f), os.path.join(dst_fonts, f))

# Audio soundtracks & Foley
print("   -> Copying OST & sound effects...")
dst_audio = os.path.join(DEST_DIR, "audio")
os.makedirs(os.path.join(dst_audio, "music"), exist_ok=True)
os.makedirs(os.path.join(dst_audio, "sfx"), exist_ok=True)

music_src = os.path.join(GAME_DIR, "audio", "_music")
if os.path.exists(music_src):
    for root, _, files in os.walk(music_src):
        for f in files:
            if f.endswith(".flac"):
                for key_track in ["The Long Quiet", "The Witch", "The Tower", "The Thorn", "The Stranger", "main_menu"]:
                    if key_track in f:
                        shutil.copy2(os.path.join(root, f), os.path.join(dst_audio, "music", f))

sfx_src = os.path.join(GAME_DIR, "audio", "one_shot")
if os.path.exists(sfx_src):
    for f in ["door_close.flac", "door_bedroom.flac", "chain_1.flac", "knife_slice.flac", "Glass_1.flac", "footsteps_creaky.flac"]:
        src_f = os.path.join(sfx_src, f)
        if os.path.exists(src_f):
            shutil.copy2(src_f, os.path.join(dst_audio, "sfx", f))

# Spoken Voice Acting (Narrator, Voices, Princess)
print("   -> Copying voice acting dialogue lines...")
voices_dst = os.path.join(dst_audio, "voices")
os.makedirs(voices_dst, exist_ok=True)
voices_src = os.path.join(GAME_DIR, "audio", "voices")
if os.path.exists(voices_src):
    voice_files = {
        # Narrator Chapter 1 & Cabin
        "ch1/woods/narrator/woods_1.flac": "narrator_woods_1.flac",
        "ch1/woods/narrator/woods_2.flac": "narrator_woods_2.flac",
        "ch1/knife/narrator/knife_1.flac": "narrator_cabin_blade.flac",
        "ch1/shared/narrator/stairs_1.flac": "narrator_basement_stairs.flac",
        # Hero & Core Voices
        "ch1/woods/hero/woods_hero_1.flac": "hero_hesitant.flac",
        "ch1/knife/hero/knife_hero_1.flac": "hero_dangerous.flac",
        "ch2/adversary/stubborn/ch2_stubborn_1.flac": "voice_stubborn.flac",
        "ch2/beast/hunted/ch2_hunt_1.flac": "voice_hunted.flac",
        "ch2/damsel/smitten/ch2_smitten_1.flac": "voice_smitten.flac",
        "ch2/nightmare/paranoid/ch2_paranoid_1.flac": "voice_paranoid.flac",
        "ch2/prisoner/skeptic/ch2_skeptic_1.flac": "voice_skeptic.flac",
        "ch2/razor/cheated/1.flac": "voice_cheated.flac",
        "ch2/spectre/cold/ch2_cold_1.flac": "voice_cold.flac",
        "ch2/stranger/contrarian/bonus1.flac": "voice_contrarian.flac",
        "ch2/tower/broken/ch2_broken_1.flac": "voice_broken.flac",
        "ch2/witch/opportunist/ch2_opportunist_1.flac": "voice_opportunist.flac",
        # Princess Chapter 1 & 2
        "ch1/empty/princess/empty_p_1.flac": "princess_empty_1.flac",
        "ch1/empty/princess/empty_p_10.flac": "princess_chains.flac",
        "ch1/empty/princess/empty_p_55.flac": "princess_empty_2.flac",
        "ch1/knife/princess/stab_p_1.flac": "princess_who_there.flac",
        "ch2/tower/princess/ch2_tp_1.flac": "princess_come_down.flac",
        "ch2/damsel/princess/ch2_dp_1.flac": "princess_damsel.flac",
        "ch2/witch/princess/ch2_wp_1.flac": "princess_witch.flac",
        "ch2/nightmare/princess/ch2_np_1.flac": "princess_nightmare.flac",
        "caught/innocent.flac": "princess_innocent.flac"
    }
    for rel_src, dst_name in voice_files.items():
        s = os.path.join(voices_src, rel_src)
        if os.path.exists(s):
            shutil.copy2(s, os.path.join(voices_dst, dst_name))

# Mark verification stamp
with open(os.path.join(DEST_DIR, ".verified"), "w") as vf:
    vf.write(f"game_dir={GAME_DIR}\nstatus=verified\n")
print("   -> Curation complete!")
PYEOF

echo ">> 3. Building cursor theme..."
"$ROOT/scripts/build-cursor-theme.sh" || true

echo ">> Asset pipeline completed successfully!"
