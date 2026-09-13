# slaytheland 🗡️👑
## Complete Architectural Master Plan & Feature Specification

A *Slay the Princess* themed desktop environment for Hyprland, built natively in **Quickshell** (QML) with full feature parity to [`hyprmilk`](https://github.com/linuxnoodle/hyprmilk), featuring multi-vessel Princess companion dynamics, layered parallax environments, living-pencil GLSL shaders, authentic voice acting integration, hand-drawn UI frames, and a dedicated Hyprlock interface.

---

## 1. System Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────────────────────────────┐
│                                       HYPRLAND COMPOSITOR                                   │
├─────────────────────────────────────────────────────────────────────────────────────────────┤
│                                     QUICKSHELL RUNTIME (0.3.x)                              │
│                                                                                             │
│  ┌───────────────────────┐  ┌────────────────────────┐  ┌────────────────────────────────┐  │
│  │   BACKGROUND & ROOMS  │  │  INTERACTIVE COMPANION  │  │        DESKTOP SURFACES        │  │
│  │   (bg/Bg.qml)         │  │  (bg/Princess.qml)      │  │                                │  │
│  │  • Parallax depth     │  │  • Multi-vessel engine  │  │  • Bar (bar/Bar.qml)           │  │
│  │  • Scene switching    │  │  • Idle / Talk frames   │  │  • Control Center (SUPER+Q)    │  │
│  │  • Skybox crossfades  │  │  • Cursor tilt & gaze   │  │  • App Launcher (SUPER+SPACE)  │  │
│  │  • GLSL Pencil Boil   │  │  • Mood drift & click   │  │  • OSD Popups (Volume/Bright)  │  │
│  │  • Focus window pause │  │  • Window-focus freeze  │  │  • Notification Toasts & Center│  │
│  └───────────────────────┘  └────────────────────────┘  └────────────────────────────────┘  │
│                                                                                             │
│  ┌────────────────────────────────────────────────────────────────────────────────────────┐ │
│  │                          CORE SERVICES & DATA BUS (Singletons)                         │ │
│  │                                                                                        │ │
│  │   Theme.qml        RoomState.qml       Sfx.qml            Music.qml     VoiceBus.qml   │ │
│  │   (Colors/Fonts/   (Active scene &     (Foley, clicks,    (FLAC OST,    (Narrator &    │ │
│  │    9-slice frames)  vessel state)       typewriter loops)  intro+loop)   Voice lines)  │ │
│  └────────────────────────────────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────────────────────────────┘
          │                                                                      │
          ▼                                                                      ▼
┌───────────────────────────────────────┐              ┌──────────────────────────────────────┐
│       DESKTOP AUDIO ENGINE (mpv)      │              │            STANDALONE LOCK           │
│  • Looping cabin / wind ambience      │              │         (hypr/hyprlock.conf)         │
│  • Voice event triggers (IPC)         │              │  • Hand-drawn 9-slice frame dialog   │
│  • Colin Stetson FLAC soundtrack      │              │  • The Mirror / Princess portrait    │
│  • Typewriter talking loop SFX        │              │  • Authentic Narrator audio greeting │
└───────────────────────────────────────┘              └──────────────────────────────────────┘
```

---

## 2. Game Ownership & Asset Pipeline (The `hyprmilk` Model)

Following the precedent set by [`linuxnoodle/hyprmilk`](https://github.com/linuxnoodle/hyprmilk), **no copyrighted game assets (graphics, music, voice files, or proprietary visual novel scripts) are bundled or committed to git**.

To install and use `slaytheland`, the user **must legally own and have installed *Slay the Princess***.

### 2.1 Ownership Verification Architecture
* **Steam App ID**: `1989270` (*Slay the Princess* / *The Pristine Cut*).
* **Archive Path**: `steamapps/common/Slay the Princess/game/archive.rpa`.
* **Automated Detection (`tools/detect_game.sh`)**:
  1. Inspects default Steam library locations (`~/.local/share/Steam`, `~/.steam/steam`).
  2. Parses `libraryfolders.vdf` to scan any external SSD or secondary Steam library paths.
  3. Validates presence of `steamapps/appmanifest_1989270.acf` and `archive.rpa`.
  4. Supports manual path override: `./tools/install.sh "/custom/path/to/Slay the Princess"`.
  5. If the game is not detected, the installer **strictly halts** with an educational and supportive prompt:
     ```
     ================================================================================
     slaytheland requires an authentic installation of "Slay the Princess".
     Support Black Tabby Games by purchasing the game:
     • Steam: https://store.steampowered.com/app/1989270/Slay_the_Princess/
     • GOG:   https://www.gog.com/en/game/slay_the_princess
     ================================================================================
     Error: archive.rpa not found. Please install the game and re-run this script.
     ```

### 2.2 Local Asset Pipeline (`tools/`)
All curation happens entirely on the user's local machine:
* `tools/extract.sh`: Runs local Python extraction from `archive.rpa` into `assets/` (which is strictly `.gitignore`'d).
* `tools/slice_frame.py`: Extracts and slices `gui/frame.png` for QML 9-slice borders.
* `tools/dialogue.py`: Ingests the game's `.rpy` dialogue scripts and compiles `data/dialogue.js`.
* `tools/gen_manifests.py`: Scans extracted backgrounds and vessels to compile `data/rooms.js` and `data/vessels.js`.
* `tools/install.sh`: Master one-click installer for new users:
  1. Verifies game ownership and installation.
  2. Extracts and curates local assets.
  3. Builds the `SlayThePrincess` XCursor theme.
  4. Copies official TTF fonts into `~/.local/share/fonts/slaytheland/` and triggers `fc-cache`.
  5. Links Quickshell configs to `~/.config/quickshell/slaytheland`.

### 2.3 Runtime Protection (`shell.qml`)
If a user launches `slaytheland` without running `install.sh` or if the assets are deleted, Quickshell does not crash. Instead, it renders an atmospheric fallback dialogue card:
> *"You're on a path in the woods, but there is no cabin here. You must bring the world into existence by possessing the story. Please install Slay the Princess and run ./tools/install.sh."*

---

## 3. Visual Style & Design Tokens (`Theme.qml`)

### 2.1 Color Palette
| Token | Hex Value | Description |
|---|---|---|
| `voidBlack` | `#0d0b0f` | Pure shadow, terminal and window backings |
| `charcoal` | `#151218` | Primary panel and dialog surfaces |
| `surfaceAlt` | `#1e1922` | Raised button surfaces, active inputs |
| `graphiteMuted`| `#483f4d` | Muted borders, inactive workspace glyphs |
| `pencilLight` | `#706578` | Subtext, timestamps, inactive chips |
| `parchment` | `#e8ddc5` | Primary foreground text (antique yellowed paper) |
| `parchmentWhite`| `#fbf5e6`| Active headers, hovered text |
| `bloodDried` | `#801336` | Inactive accent border, subtle badges |
| `crimson` | `#c72c41` | Active workspace highlight, alerts, blade cursor |
| `crimsonVivid` | `#e02438` | High-priority warnings, urgent notification border |
| `amber` | `#d4a373` | Candlelight warnings, CPU high-usage threshold |

### 2.2 Typography
1. **`Kelmscott Roman NF`**: Medieval woodcut serif.
   * *Usage*: Workspaces (`I`, `II`, `III`, `IV`, `V`), Bar clock, Chapter title cards, Lock screen greeting.
2. **`Amatic SC` (Bold & Regular)**: Iconic hand-drawn pencil sans-serif.
   * *Usage*: Dialogue box text, window titles, vitals readouts, system menus, tooltips.
3. **`East Sea Dokdo`**: Frenzied ink-scratch horror font.
   * *Usage*: Critical alerts, system failure warnings, Voice of the Paranoid / Hunted interruptions.

### 2.3 9-Slice Hand-Drawn Frames (`widgets/Border.qml`)
* Extracted from `gui/frame.png` (900×375 RGBA) and `gui/textbox.png`.
* Implemented via QML `BorderImage` with 16px to 24px corner borders.
* Used for:
  - Dialogue textboxes
  - Control center and launcher containers
  - OSD volume/brightness sliders
  - Notification toast cards

---

## 3. Quickshell Architecture & Components

### 3.1 Directory Structure
```
~/Projects/slaytheland/quickshell/
├── shell.qml                     # Quickshell root entrypoint (GlobalShortcut handlers)
├── qmldir                        # Module declarations & singletons
├── Theme.qml                     # Color tokens, fonts, border metrics
├── RoomState.qml                 # State machine for current room & vessel
├── Sfx.qml                       # Sound effects coordinator (mpv / PipeWire)
├── Music.qml                     # Ambient music & radio player
├── VoiceBus.qml                  # Voice events and audio quip manager
├── Cursor.qml                    # Parallax coordinate tracker
├── services/                     # Core system services (reused & adapted from Ryoku)
│   ├── Audio.qml                 # PipeWire live sink/source mixer & debounce
│   ├── Battery.qml               # UPower battery health, charge state & onAc
│   ├── Notifs.qml                # NotificationServer with DND & auto-expiry
│   ├── Session.qml               # Session uptime, hostname, and power execution
│   └── ShellState.qml            # Per-monitor screen state bus (Variants over screens)
├── shaders/
│   ├── pencil_boil.frag          # GLSL line-distortion shader (12 fps line boil)
│   └── vignette.frag             # Dark sketch edge vignette
├── bg/
│   ├── Bg.qml                    # Layered background compositor
│   ├── ParallaxLayer.qml         # Depth-offset plane
│   ├── Princess.qml              # Interactive companion character
│   └── PrincessAnimator.qml      # Breathing, blinking, talking animation
├── bar/
│   ├── Bar.qml                   # Top status bar surface
│   ├── Workspaces.qml            # Roman numeral workspace chips (I to V)
│   ├── WindowTitle.qml           # Amatic SC window title
│   ├── ClockWidget.qml           # Kelmscott clock & calendar dropdown
│   ├── MprisWidget.qml           # Colin Stetson radio / media player
│   ├── VitalsWidget.qml          # Heart (CPU) & Memory readouts
│   ├── VoiceToggle.qml           # Voice acting mute/unmute icon
│   └── VesselSelector.qml        # Princess vessel dropdown button
├── dialogue/
│   ├── Box.qml                   # Dialogue window
│   ├── Typewriter.qml            # 20 chars/sec text reveal engine
│   └── SpeakerTag.qml            # Namebox for Narrator, Voices, Princess
├── quicksettings/                # Quick Settings Sidebar (SUPER+ESCAPE)
│   ├── QuickSettingsSidebar.qml  # Hand-drawn parchment/charcoal sidebar
│   ├── QuickSettingsTiles.qml    # Wi-Fi, Bluetooth, Night Light, Companion, Voice
│   ├── SlaySlider.qml            # Hand-drawn pencil slider with blade thumb
│   ├── MediaHero.qml             # Colin Stetson FLAC / MPRIS player card
│   └── PowerChoices.qml          # Slay/Turn Back/Restart narrative choices
├── hub/                          # Settings Hub (SUPER+COMMA)
│   ├── SettingsHub.qml           # Full-screen modal customization hub
│   ├── VesselPickerPage.qml      # Visual Princess vessel selector & preview
│   ├── RoomPickerPage.qml        # Multi-plane room scene selector
│   ├── ShadersPage.qml           # Pencil boil intensity & performance toggle
│   └── AudioPage.qml             # Voice volume, Narrator/Voices balance
├── launcher/
│   ├── Launcher.qml              # SUPER+SPACE application launcher
│   └── SearchItem.qml            # Choice-styled entry
├── notifs/
│   ├── Toasts.qml                # Overlay popup notification banner
│   └── Center.qml                # Notification history center (SUPER+N)
├── osd/
│   └── Osd.qml                   # Volume and brightness popup HUD
├── widgets/
│   ├── Border.qml                # 9-slice charcoal frame component (gui/frame.png)
│   └── CharcoalButton.qml        # Slay the Princess styled button
└── data/
    ├── dialogue.js               # Ingested game scripts & narrator quotes
    ├── vessels.js                # Sprite manifests per Princess form
    └── rooms.js                  # Parallax plate layer manifests
```

---

### 3.2 Open-Source Reuse: Borrowing from Ryoku
Rather than reinventing complex system daemons, `slaytheland` borrows proven architectural patterns from the user's host system (**Ryoku**) and wraps them in authentic visual novel aesthetics:

1. **Hyprland GlobalShortcuts Protocol (`GlobalShortcut`)**:
   - Hyprland dispatches chords (`bind = $mod, SPACE, global, slay:launcher`) straight into Quickshell via `Quickshell.Hyprland.GlobalShortcut`.
   - Zero-spawn overhead: no bash scripts or python wrappers run on keypress; state flips in 0ms inside the existing QML process.
2. **Robust Hardware Singletons (`services/`)**:
   - `Audio.qml`: Leverages `Quickshell.Services.Pipewire` with Ryoku's settled snapshot debounce to eliminate repeater crashes during audio device changes.
   - `Battery.qml`: UPower display device tracker that accurately differentiates line-power (`onAc`) from battery drain.
   - `Notifs.qml`: Flat newest-first notification model with transient popup display deadlines and DND suppression.
   - `Session.qml`: Direct `/proc/uptime` reader keeping track of loop duration without polling CPU.
   - `ShellState.qml`: Uses `Variants` over `Quickshell.screens` so multi-monitor setups maintain isolated surface memory.
3. **Quick Settings & Hub Patterns**:
   - Adapts Ryoku's `QuickSettingsHome.qml` into `QuickSettingsSidebar.qml` (bound to `SUPER + Escape`).
   - Adapts Ryoku's Hub design into `SettingsHub.qml` (bound to `SUPER + comma`), providing a rich GUI for switching Princess vessels, room plates, skyboxes, and voice acting toggles.

## 4. Feature Specifications (Feature Parity with `hyprmilk`)

### 4.1 Layered Room Engine & Backgrounds (`bg/Bg.qml`)
* **Room Scenes (`data/rooms.js`)**:
  1. **The Path in the Woods**: `skyline`, `quiet path backtrees`, `midground path`, `quiet path foreground`.
  2. **The Cabin Exterior**: `skyline cabin`, `midground cabin`, `bg cabin` (the cabin plate), `foreground cabin` (brush & weeds).
  3. **The Cabin Interior**: `farback interior cabin` (walls & door), `bg interior cabin` (table & floor), `knife interior cabin` (the blade).
  4. **The Basement Stairs**: `bg basement stairs`, `front basement stairs` (doorframe cutout).
  5. **The Distant Basement**: `bg basement distant`, `distant basement`, `back basement distant` (shackles & shadows).
  6. **The Mirror Room**: `special/farback quiet`, `special/mirror quiet distant`, `mirror frame`, `player mirror`.
  7. **CG Wallpaper Mode**: Direct selection from the 439+ high-resolution illustrations.
* **Compositing**:
  - Sky/Distant layer renders at back.
  - Intermediate room plate punches out window/door alpha regions so the sky or background is visible through them.
  - Foreground layer overlays bottom screen edges for dramatic depth.
* **Parallax Mechanics**:
  - Cursor tracking with depth coefficient: Background moves at `0.02x`, Midground at `0.05x`, Foreground at `0.10x`.
  - When windows are focused: Scene gently freezes in place over 400ms.
  - When desktop is focused: Scene eases back to life.
* **Controls**:
  - `SUPER + W`: Cycle sky / mood / CG layer (700ms crossfade).
  - `SUPER + S`: Cycle room scene (Woods -> Cabin -> Basement -> Mirror).

---

### 4.2 Interactive Princess Companion (`bg/Princess.qml`)

#### Multi-Vessel State Engine (`data/vessels.js`)
Users can switch which Princess stands on their desktop via hotkey (`SUPER + G`) or the top bar menu:
* **Chapter 1**: The Princess (Neutral, Soft, Harsh, Coy, Dagger variants).
* **Chapter 2 Routes**:
  * **The Damsel**: Pure, upbeat, eager smiles, waving.
  * **The Witch**: Smug smirk, crouching, feral hiss, leaf-tangled hair.
  * **The Nightmare**: Skull mask, shadowy tendrils, glowing hollow eyes, blood tears.
  * **The Tower**: Regal, looming, imposing gaze, golden charcoal aura.
  * **The Razor**: Blade-sleeves, manic grin, mechanical precision poses.
  * **The Adversary**: Muscular, battle-worn, sparring stance, bruised grin.
  * **The Spectre**: Ethereal, floating, semi-transparent ghost, sorrowful gaze.
  * **The Prisoner**: Chained neck, cold calculating stare, holding severed head.
  * **The Beast**: Predatory slouch, fanged maw, coiled muscle.
  * **The Stranger**: Glitching multi-faceted fragments, shifting simultaneously.
* **Chapter 3 Evolutions**:
  * **The Thorn**: Vine-wrapped, tangled, guarded softness, blushing smile.
  * **The Apotheosis**: Cosmic deity, towering hands, blinding light.
  * **The Moment of Clarity**: Multi-masked weeping horror, fractured flesh.
  * **The Eye of the Needle**: Gigantic spiked armor, fierce warlord.
  * **The Den**: Massive hibernating predator.
  * **The Fury**: Flayed visceral titan, dripping sinew.
  * **The Grey**: Drowned water-logged tears or burning ash embers.
  * **The Wild**: Tree-fused symbiotic nature vessel.

#### Animation & Interaction Loops
* **Idle Breathing**: Subtle procedural sine-wave scaling (`scaleY: 1.0 + 0.015 * sin(t)`, `origin: bottom`).
* **Eye Blinking**: Random blink timer (every 3 to 7 seconds, quick 120ms eye-shut sprite swap).
* **Dialogue Lip-Sync**: When dialogue plays, rapidly alternates between base sprite (`*.png`) and matching `* talk.png` at 8 Hz until typewriter completes.
* **Cursor Gaze / Leaning**: Companion squashes and leans slightly toward the mouse cursor across X and Y axes.
* **Click Interaction**: Clicking the Princess cycles her emotion / pose (e.g. Neutral -> Coy -> Tsundere -> Blush -> Armed).
* **Idle Mood Drift**: Left alone, her mood drifts every 2 minutes into gentle contemplation or watchful stillness.
* **Toggle**: `SUPER + G` hides/shows the companion with a fade-and-sink animation.

---

### 4.3 Living-Pencil Boil GLSL Shader (`shaders/pencil_boil.frag`)

Reproduces the signature hand-drawn line vibration from the game's original `shader.rpy`:
* **Implementation**: QML `ShaderEffect` applying a fragment shader to the background plates and window borders.
* **Algorithm**:
  * 2D Worley/Perlin noise texture coordinate displacement.
  * Stepped animation frame sampling (`floor(time * 12.0)` — locked to visual novel 12 fps).
  * Subtle horizontal line interlacing wiggle (`sin(uv.y * 80.0 + frame) * 0.002`).
  * Vignette darkening on window borders and display edges.
* **Performance Mode**: Toggleable setting to disable the shader and run static textures on battery power.

---

### 4.4 Authentic Voice Acting & Sound Effects (`VoiceBus.qml` & `Sfx.qml`)

Leverages the 13,300 extracted audio files from `game/audio/`:

#### Desktop Event Voice Triggers
| Event | Character / Voice | Sample Voiceline | Audio Source |
|---|---|---|---|
| **System Startup / Login** | The Narrator (Jonathan Sims) | *"You're on a path in the woods, and at the end of that path is a cabin."* | `voices/ch1/woods/` |
| **Lock Screen Opened** | The Narrator | *"The interior of the cabin is clean and sparse. There's a door leading to the basement."* | `voices/ch1/empty/` |
| **Wrong Password in Lock** | Voice of the Skeptic | *"Did you really think that would work? Try to think this through."* | `voices/ch1/voices/` |
| **Battery Critical (<15%)** | Voice of the Paranoid | *"Our heart is slowing down... is it stopping?! We need to plug in right now!"* | `voices/ch1/voices/` |
| **Failed Terminal Command** | Voice of the Stubborn | *"Get back up. We're not dead yet. Hit it again!"* | `voices/ch1/voices/` |
| **Workspace 1 Selected** | Voice of the Hero | *"Let's see what we're dealing with."* | `voices/ch1/voices/` |
| **High CPU / Heavy Load** | Voice of the Hunted | *"Something is coming. It's fast, and it's hungry."* | `voices/ch1/voices/` |
| **App Launcher Opened** | Voice of the Opportunist | *"Now this... this is an opportunity. Let's make sure we come out on top."* | `voices/ch1/voices/` |
| **Music Play / Radio** | Voice of the Smitten | *"Listen to that melody... isn't she magnificent?"* | `voices/ch1/voices/` |
| **System Shutdown / Quit** | The Princess | *"I hope we find each other again in whatever comes next."* | `voices/felina/` |

#### UI Sound Effects (Foley)
* **Workspace Switch**: `footsteps_creaky.flac` or `footstep_stone.flac`.
* **Window Close / Kill**: `Glass_1.flac` (sharp glass snap).
* **Window Tile / Move**: `chain_1.flac` to `chain_6.flac` (subtle iron link clink).
* **Volume Adjustment**: `knife_slice.flac` (blade drawing from sheath).
* **Screen Lock**: `door_close.flac` (heavy cabin door slam & lock latch).
* **Master Mute**: A dedicated toggle in the top bar (`VoiceToggle.qml`) mutes all voice lines while leaving music/system audio intact.

---

### 4.5 Dialogue Typewriter System (`dialogue/Box.qml`)

* **Visuals**: Sits above the bar or bottom center, drawn with `gui/textbox.png` and `gui/namebox.png`.
* **Typewriter Engine**: Reveals text character-by-character at the game's exact rate (**20 characters per second**).
* **Talking Audio Loop**: Synchronized playback of typewriter audio chatter (`narr.ogg` / talking loop) while text scrolls, fading out on completion.
* **Content Engine (`data/dialogue.js`)**:
  * Compiled directly from the game's uncompressed `.rpy` scripts.
  * Organizes lines by character: The Narrator, Voice of the Hero, Paranoid, Skeptic, Smitten, Cold, Stubborn, Broken, Opportunist, Hunted, and the current active Princess form.
* **Triggers**:
  * `SUPER + X`: Display a random context-aware dialogue quote on demand.
  * Room transitions (e.g. first entering the Cabin or Basement).
  * Gentle timer: Triggers an ambient quote every 10 to 15 minutes.
* **Controls**: Click once to skip the typewriter and show full text; click again to dismiss.

---

### 4.6 Status Bar (`bar/Bar.qml`)

* **Placement**: Top edge with 6px floating margin, 10px screen edge margin.
* **Background Frame**: 9-slice hand-drawn pencil border (`Border.qml`) over semi-transparent `#110f13`.
* **Modules**:
  1. **Launcher Emblem (`🗡️`)**: Blade button that opens the Quickshell app launcher.
  2. **Workspaces (`bar/Workspaces.qml`)**:
     * Woodcut Roman numerals (`I`, `II`, `III`, `IV`, `V`) in `KelmscottRomanNF`.
     * State chips:
       * Empty workspace: Hollow charcoal outline.
       * Workspace with open windows: Solid parchment tint.
       * Active workspace: Vibrant crimson background (`#c72c41`) with white text and blood-red underline.
  3. **Active Window Title**: Current focused app in `Amatic SC`.
  4. **Clock & Calendar**: Formatted as `Day, Month Date · HH:MM` in `KelmscottRomanNF`. Clicking opens a hand-drawn calendar dropdown.
  5. **MPRIS Radio Widget**: Displays track name and play/pause controls for Colin Stetson's ambient score or user music.
  6. **Vitals**: `HEART` (CPU %) and `MEM` (RAM %) in `Amatic SC` with warning color states.
  7. **Princess Vessel Picker**: Icon showing the current Princess form; clicking opens a quick selector menu.
  8. **Voice Line Toggle**: Button to quickly silence or enable voice quips.
  9. **Leave Cabin (Quit)**: Power menu trigger.

---

### 4.7 Quick Settings Sidebar & OSDs (`quicksettings/` & `osd/`)

* **Quick Settings Sidebar (`SUPER + ESCAPE`)**:
  * Bound to `SUPER + ESCAPE` via `GlobalShortcut { appid: "slay"; name: "quicksettings" }` matching the user's host Ryoku muscle memory.
  * Slides out smoothly from the right edge in a hand-drawn 9-slice charcoal and parchment frame.
  * **Header**:
    * Clock in `KelmscottRomanNF` with current date in `Amatic SC`.
    * Battery status pill (leveraging `services/Battery.qml`).
    * Session choice buttons (with Narrator voice prompts):
      * *"Turn Back"* (Lock Screen / Hyprlock)
      * *"Step Outside"* (Log Out)
      * *"Restart the Loop"* (Reboot)
      * *"Slay the Princess"* (Power Off / Shutdown)
  * **Quick Toggles Grid (`quicksettings/QuickSettingsTiles.qml`)**:
    * Wi-Fi & Bluetooth (instant hardware toggles).
    * Night Light (Blood red candle tint).
    * Voice Quips (silence/unmute Narrator and Voices).
    * Princess Companion (toggle desktop presence).
    * Do Not Disturb (suppress toasts).
  * **Sound & Display Sliders (`quicksettings/SlaySlider.qml`)**:
    * Volume slider connected directly to `services/Audio.qml` default audio sink.
    * Microphone slider connected to default audio source.
    * Display brightness slider.
  * **Media Player Card (`quicksettings/MediaHero.qml`)**:
    * MPRIS controller for Colin Stetson FLAC OST or running media players.
* **OSD HUD (`osd/Osd.qml`)**:
  * Pops up centered on volume or brightness hotkey changes.
  * Charcoal frame with blade/sun icon and pencil-sketch level indicator, auto-fading after 1.5 seconds.

---

### 4.8 Application Launcher (`launcher/Launcher.qml`)

* Triggered with **`SUPER + SPACE`** (or tapping `Super` alone), dispatched via `slay:launcher`.
* Centered 520×380 modal container with charcoal 9-slice border and subtle line boil.
* Top search input styled after the visual novel dialogue prompt (*"What will you do?..."*).
* App list filtered in real-time using desktop entries (`.desktop`).
* Highlighted entry draws the game's choice background (`gui/button/choice_hover_background.png`) with crimson glow.
* Special action commands built-in:
  * `:vessel <name>` (Instantly switch Princess form)
  * `:room <name>` (Switch scene plate)
  * `:talk` (Trigger dialogue line)
  * `:wall` (Cycle wallpaper)

---

### 4.9 Customization Settings Hub (`hub/SettingsHub.qml`)

* Triggered with **`SUPER + comma`** (or via the Quick Settings gear), dispatched via `slay:hub`.
* Full-screen visual customization studio inspired by Ryoku's Settings Hub:
  * **Princess Sanctuary**: Visual gallery of all 18+ Princess vessels with live previews, allowing one-click selection.
  * **Cabin & Scenery**: Switch between the Woods, Cabin Exterior, Interior, Basement Stairs, Distant Basement, and Mirror.
  * **Sky & Atmosphere**: Choose specific time-of-day skies and CG backgrounds.
  * **Living Pencil Shaders**: Adjust line-boil intensity (0 to 100%) or enable battery-saver static mode.
  * **Voice & Audio Mixing**: Independent volume sliders for The Narrator, The Voices, Princess, and Foley SFX.

---

### 4.10 Themed Hyprlock (`hypr/hyprlock.conf`)

Dedicated lock screen eliminating the need for a display manager (SDDM):
* **Background**: The Distant Cabin or The Mirror Room with a dark blur pass and heavy charcoal sketch vignette.
* **Avatar / Centerpiece**: A circular hand-drawn frame showing the Mirror reflection or the Princess watching.
* **Greeting Text**: Rendered in `KelmscottRomanNF` at 28px:
  > *"You're on a path in the woods..."*
* **Password Box**:
  * Charcoal fill with crimson border (`#c72c41`).
  * Dots masked with blade or charcoal circles.
  * Placeholder: *"Take the blade and enter..."*
* **Fail State**:
  * Border flashes blood crimson (`#e02438`).
  * Subtitle shifts to `EastSeaDokdo` font: *"She will kill you if you fail."*
  * Plays Skeptic / Paranoid voice line on incorrect attempt.
* **Unlock Sound**: Plays `door_close.flac` as the screen fades smoothly into the desktop session.

---

## 5. Implementation Roadmap & Milestones

```
Phase 1: Foundation (COMPLETED)
├── Verified QEMU/KVM Sandbox with Arch Linux + Hyprland
├── Curated 115 UI frames, 4 fonts, 195 scene plates, 439 wallpapers, FLAC audio
├── Built Waybar, Wofi, Kitty theme, and SlayThePrincess cursor theme
└── Verified VM boot, SSH connectivity, and 9p bidirectional shared folder

Phase 2: Quickshell Core & Layered Wallpaper Engine
├── Install quickshell in the VM sandbox
├── Scaffold quickshell/ directory with qmldir and Theme.qml
├── Adapt Ryoku services: Audio.qml, Battery.qml, Notifs.qml, Session.qml, ShellState.qml
├── Implement widgets/Border.qml (9-slice QML frame component from gui/frame.png)
├── Build RoomState.qml & bg/Bg.qml (Multi-plane parallax scene compositor)
├── Implement GLSL pencil_boil.frag living-sketch line shader
└── Hook SUPER+W to sky/mood cycle and SUPER+R to room scene switcher

Phase 3: The Interactive Princess Companion
├── Build bg/Princess.qml & data/vessels.js
├── Implement sprite rigging (Idle vs Talk pairs, eyes blinking, breathing pulse)
├── Add cursor gaze tracking (squashing/leaning toward mouse)
├── Add click interaction (cycle emotion/pose) and idle mood drift
└── Wire focus-window freeze and SUPER+G companion toggle

Phase 4: Audio Engine & Voice Event Bus
├── Build Sfx.qml & VoiceBus.qml wrapping mpv IPC
├── Implement event listeners for Hyprland IPC (workspaces, active window)
├── Map system vitals (low battery, failed command, high CPU) to Voice lines
├── Build dialogue/Box.qml with 20 chars/sec typewriter and talking audio loop
└── Wire SUPER+X on-demand dialogue trigger and volume Foley SFX

Phase 5: Desktop Surfaces (Bar, Quick Settings Sidebar, Launcher, Hub & OSD)
├── Implement bar/Bar.qml with Roman numeral chips, clock, and vessel picker
├── Build quicksettings/QuickSettingsSidebar.qml (SUPER+ESCAPE) adapted from Ryoku
├── Build hub/SettingsHub.qml (SUPER+comma) for Princess/Room/Audio customization
├── Build launcher/Launcher.qml (SUPER+SPACE) with custom commands
├── Build osd/Osd.qml and notifs/Toasts.qml
└── Wire Hyprland GlobalShortcut dispatchers for 0ms latency

Phase 6: Themed Hyprlock & Direct Boot
├── Configure hypr/hyprlock.conf with Mirror/Princess art & Kelmscott fonts
├── Add audio greeting on lock and unlock sound effects
├── Configure auto-login straight into Hyprland (bypassing SDDM)
└── Package self-contained slaytheland-portable bundle
```

---

## 6. Keybinds Master Reference

Aligned 1:1 with the user's host Ryoku muscle memory:

| Shortcut | Action | Component / Target |
|---|---|---|
| `SUPER + Return` | Launch Kitty terminal (Parchment & Charcoal theme) | Kitty |
| `SUPER + SPACE` (or tap `Super`) | Open Slay the Princess App Launcher | `slay:launcher` (Quickshell) |
| `SUPER + Escape` | Open Quick Settings Sidebar (Audio, Toggles, Power) | `slay:quicksettings` (Quickshell) |
| `SUPER + comma` | Open Slaytheland Settings Hub (Vessels, Rooms, Shaders) | `slay:hub` (Quickshell) |
| `SUPER + Q` | Close active window (killactive) | Hyprland `close()` |
| `SUPER + W` | Cycle Wallpaper / Sky / Mood Layer (700ms crossfade) | Quickshell Background |
| `SUPER + R` | Cycle Room Scene (Woods -> Cabin -> Basement -> Mirror) | Quickshell RoomState |
| `SUPER + S` | Toggle scratchpad special workspace | Hyprland `special:scratch` |
| `SUPER + G` | Toggle Princess Companion Visibility | Quickshell Princess |
| `SUPER + X` | Reveal a random context dialogue quote with voice line | Quickshell Dialogue |
| `SUPER + F` | Toggle fullscreen | Hyprland `fullscreen()` |
| `SUPER + A` | Toggle float & center window | Hyprland `float()` |
| `SUPER + Tab` | Workspace overview | Hyprland overview |
| `SUPER + 1..5, 0` | Switch to workspace I, II, III, IV, V... | Hyprland Workspaces |
| `SUPER + Shift + 1..5` | Move active window to workspace I..V | Hyprland move |
| `SUPER + L` | Lock screen immediately into Slay the Princess Hyprlock | `hyprlock` |
| `XF86AudioRaiseVolume` | Raise volume with blade unsheathing SFX | `services/Audio.qml` |
| `XF86AudioLowerVolume` | Lower volume with blade unsheathing SFX | `services/Audio.qml` |
| `XF86AudioMute` | Toggle mute with glass snap SFX | `services/Audio.qml` |

---

*This specification serves as the master contract for developing `slaytheland`. All assets, QML modules, shaders, and configs remain cleanly isolated inside `~/Projects/slaytheland/`.*
