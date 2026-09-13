# slaytheland 🗡️👑
### A *Slay the Princess* Desktop Environment for Hyprland

[![Hyprland](https://img.shields.io/badge/Compositor-Hyprland_0.56+-c72c41?style=for-the-badge&logo=hyprland&logoColor=white)](https://hyprland.org)
[![Quickshell](https://img.shields.io/badge/Shell-Quickshell_QML-151218?style=for-the-badge&logo=qt&logoColor=white)](https://quickshell.org)
[![Arch Linux](https://img.shields.io/badge/OS-Arch_Linux-1793d1?style=for-the-badge&logo=archlinux&logoColor=white)](https://archlinux.org)
[![Zero Asset Git](https://img.shields.io/badge/Git_Assets-100%25_Legal-801336?style=for-the-badge)](https://store.steampowered.com/app/1989270/Slay_the_Princess/)

> *"You're on a path in the woods, and at the end of that path is a cabin. In the basement of that cabin is a Princess. You're here to slay her."*

---

**slaytheland** is a complete, visual-novel desktop shell for Hyprland written natively in **Quickshell (QML)**. Inspired by [`linuxnoodle/hyprmilk`](https://github.com/linuxnoodle/hyprmilk) and fortified by the hardware service architecture of **Ryoku**, it transforms your desktop into the tragic, hand-drawn world of *Slay the Princess* by Black Tabby Games.

Everything you experience comes directly from the visual novel: the living companion who watches you from the corner of your screen, multi-plane rooms that shift in perspective as you move your cursor, 12 fps living-pencil boil shaders, authentic voice acting by Jonathan Sims, Foley sound effects, and Colin Stetson's haunting FLAC soundtrack.

---

## ✨ Features

### 👑 Interactive Multi-Vessel Princess Companion
* **18+ Princess Vessels**: Switch between Chapter 1 (*The Princess*), Chapter 2 routes (*The Damsel*, *The Witch*, *The Nightmare*, *The Tower*, *The Razor*, *The Adversary*, *The Spectre*, *The Prisoner*, *The Beast*, *The Stranger*), and Chapter 3 forms (*The Thorn*, *The Apotheosis*, *The Den*, *The Moment of Clarity*).
* **Procedural Breathing**: Subtle sine-wave vertical expansion anchored at her base.
* **Random Eye Blinking**: Natural eye-closed frame swaps occurring every 3 to 7 seconds.
* **Dialogue Lip-Sync**: Rapid 8 Hz frame alternator between idle and speaking poses during voice lines.
* **Cursor Gaze & Lean**: Companions lean and track your cursor coordinates in real time.
* **Contemplative Pause**: When application windows are focused, the companion and background freeze in place, easing back to life once the desktop is re-focused.
* **Click Reactions**: Clicking the Princess triggers pristine blade Foley audio and bespoke voice quips.

### 🌲 Layered Parallax Room Engine
* **6 Iconic Environments**:
  1. *The Path in the Woods* (Skyline, Backtrees, Midground Path, Foreground Brush)
  2. *The Cabin Exterior* (Skyline, Distant Woods, Cabin Plate with Alpha Windows, Foreground Weeds)
  3. *The Cabin Interior* (Farback Walls, Table & Floor, Pristine Blade on Pedestal)
  4. *The Basement Stairs* (Stone Descent, Doorframe Cutout)
  5. *The Distant Basement* (Wall Shadows, Shackle Chains, Basement Plate)
  6. *The Mirror Room* (The Long Quiet, Cold Glass Reflection)
* **Alpha Cutouts**: Room plates punch out window and door areas, allowing dynamic time-of-day skies or visual novel CGs to peek through from behind.
* **Instant Scene Cycling**: `SUPER + R` cycles room plates; `SUPER + W` crossfades the background sky/CG layer with a smooth 700ms ease.

### ✏️ Living Pencil Boil Shader
* Custom GLSL fragment shader (`shaders/pencil_boil.frag`) pre-compiled with Qt `qsb`.
* Simulates the visual novel's signature 12 fps hand-drawn line vibration using 2D Worley noise coordinate displacement and subtle screen-edge vignette darkening.
* Includes a battery-saver static toggle accessible in the Settings Hub.

### 🗡️ Voice Bus & Dialogue Typewriter
* **20 Characters/Second Typewriter**: Authentic visual novel dialogue box (`dialogue/Box.qml`) rendered with 9-slice hand-drawn frames (`gui/frame.png`).
* **Synchronized Audio Chatter**: Plays speech sound effects during character text reveal.
* **Desktop Event Voice Triggers**:
  - *Startup / Login*: Jonathan Sims (The Narrator) introduces the path in the woods.
  - *Battery Critical (<15%)*: Voice of the Paranoid sounds the alarm.
  - *Window Kills*: Voice of the Stubborn comments on the defiance.
  - *Desktop Idle*: The Princess softly speaks to you.
  - *On-Demand Quote*: Press `SUPER + X` anytime to reveal context-aware dialogue.

### 🎛️ Desktop Surfaces (Ryoku-Inspired Architecture)
* **Top Floating Bar (`bar/Bar.qml`)**: Hand-drawn 9-slice border, blade launcher glyph, medieval woodcut Roman numeral workspaces (`I` to `V`) in `Kelmscott Roman NF` with crimson underlines, focused window title in `Amatic SC`, volume blade slider, vessel picker chip, and voice mute toggle.
* **Quick Settings Sidebar (`SUPER + Escape`)**: Adapted from Ryoku's `QuickSettingsHome.qml`. Slides out from the right:
  - Kelmscott clock & live UPower battery status pill.
  - Instant hardware toggles (Wi-Fi, Bluetooth, Candlelight Night Mode, Companion, Voice, DND).
  - Hand-drawn pencil volume, microphone, and brightness sliders with blade thumbs.
  - MPRIS media player card for Colin Stetson FLAC soundtracks.
  - Choice-styled session buttons: *"Turn Back"* (Lock), *"Step Outside"* (Logout), *"Restart the Loop"* (Reboot), *"Slay the Princess"* (Shutdown).
* **Application Launcher (`SUPER + Space`)**: Centered visual novel choice modal (*"What will you do?..."*) with fuzzy app search and custom actions (`:vessel`, `:room`, `:talk`, `:wall`).
* **Customization Settings Hub (`SUPER + comma`)**: Full-screen modal studio to switch Princess vessels, change room scenes, adjust line-boil shader strength, and balance audio mixing.
* **Themed Hyprlock (`hypr/hyprlock.conf`)**: Direct-to-desktop lock screen bypassing SDDM, featuring the Mirror Room, Kelmscott greeting, and pristine blade password input.
* **SlayThePrincess XCursor Theme**: Native cursor package featuring the hand-drawn pencil arrow, pristine blade hover pointer, bloody dagger crosshair, and shifting eye progress ring.

---

## ⚖️ Game Ownership Requirement (The `hyprmilk` Model)

In strict adherence to the precedent established by [`linuxnoodle/hyprmilk`](https://github.com/linuxnoodle/hyprmilk), **no copyrighted assets (art, CGs, music tracks, voice files, or proprietary scripts) are bundled in this repository**.

To install and run **`slaytheland`**, you **must legally own and have installed *Slay the Princess***.

Support the creators, Abby Howard and Tony Howard-Caventi (Black Tabby Games):
* **Steam**: [Slay the Princess on Steam](https://store.steampowered.com/app/1989270/Slay_the_Princess/) (App ID `1989270`)
* **GOG**: [Slay the Princess on GOG](https://www.gog.com/en/game/slay_the_princess)

---

## 🚀 Installation

### 1. Clone the Repository
```bash
git clone https://github.com/yourusername/slaytheland.git ~/Projects/slaytheland
cd ~/Projects/slaytheland
```

### 2. Run the Automatic Installer
```bash
./tools/install.sh
```
The installer will:
1. Detect your authentic *Slay the Princess* installation (scanning default and secondary Steam libraries via `libraryfolders.vdf`).
2. Extract the required GUI frames, fonts, background plates, wallpapers, music, and voice lines directly on your machine into `assets/` (which is strictly `.gitignore`'d).
3. Build and install the `SlayThePrincess` XCursor theme.
4. Install the game's official typography fonts (`Amatic SC`, `Kelmscott Roman NF`, `East Sea Dokdo`) to `~/.local/share/fonts/slaytheland/`.
5. Link the Quickshell configuration into `~/.config/quickshell/slaytheland`.

*If your game is installed in a non-standard location, pass the path directly:*
```bash
./tools/install.sh "/path/to/Slay the Princess/game"
```

---

## ⌨️ Keybinds Grimoire

Aligned to natural muscle memory:

| Shortcut | Action | Component / Target |
|---|---|---|
| `SUPER + Return` | Open Kitty Terminal (Charcoal & Parchment) | Terminal |
| `SUPER + Space` | Open Slay the Princess App Launcher | `slay:launcher` (Quickshell) |
| `SUPER + Escape` | Toggle Quick Settings Sidebar (Audio, Power, Toggles) | `slay:quicksettings` (Quickshell) |
| `SUPER + comma` | Open Slaytheland Customization Hub (Vessels, Rooms) | `slay:hub` (Quickshell) |
| `SUPER + Q` | Close Active Window (`killactive`) | Hyprland |
| `SUPER + W` | Cycle Wallpaper / Sky Layer (700ms crossfade) | Quickshell Background |
| `SUPER + R` | Cycle Room Scene (Woods $\rightarrow$ Cabin $\rightarrow$ Basement $\rightarrow$ Mirror) | Quickshell RoomState |
| `SUPER + G` | Toggle Princess Companion Desktop Presence | Quickshell Princess |
| `SUPER + X` | Trigger Visual Novel Dialogue Quote with Audio Loop | Quickshell Dialogue |
| `SUPER + S` | Toggle Scratchpad Special Workspace | Hyprland `special:scratch` |
| `SUPER + K` | Toggle Keybind Grimoire Cheatsheet | `slay:cheatsheet` (Quickshell) |
| `SUPER + F` | Toggle Fullscreen Window | Hyprland |
| `SUPER + A` | Toggle Floating Window (Centered 1000×660) | Hyprland |
| `SUPER + 1..5` | Switch to Workspace I, II, III, IV, or V | Hyprland |
| `SUPER + Shift + 1..5` | Move Active Window to Workspace I..V | Hyprland |
| `SUPER + L` | Lock Screen into Slay the Princess Hyprlock | `hyprlock` |
| `XF86AudioRaise/Lower` | Adjust Volume (Pristine Blade OSD & Foley SFX) | `services/Audio.qml` |
| `XF86AudioMute` | Mute Audio (Glass Snap SFX) | `services/Audio.qml` |

---

## 🛡️ Isolated VM Sandbox Testing

`slaytheland` comes with a pre-configured QEMU/KVM Arch Linux sandbox so you can test, modify, and preview the desktop without touching your primary host system:

```bash
# Launch graphical VM window with 3D VirGL acceleration:
./run.sh

# Connect via SSH from host terminal:
./ssh.sh

# Instant 1-second rollback (resets CoW delta overlay to clean base):
./vm/reset-vm.sh
```

---

## 📜 Credits & Acknowledgments

* **[Black Tabby Games](https://blacktabbygames.com)** (Abby Howard & Tony Howard-Caventi) for creating the masterpiece visual novel *Slay the Princess*.
* **Jonathan Sims** for the iconic voice acting of The Narrator and The Voices.
* **Colin Stetson** for the haunting, atmospheric soundtrack.
* **linuxnoodle** for [`hyprmilk`](https://github.com/linuxnoodle/hyprmilk), which inspired the multi-plane parallax and legal local-extraction model.
* **[Ryoku](https://github.com/ryoku)** for the robust PipeWire/UPower singletons, `GlobalShortcut` dispatch architecture, and desktop service design patterns.

---
*May you never leave the cabin without the blade.* 🗡️
