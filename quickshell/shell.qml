//@ pragma UseQApplication
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import "."
import "services"
import "bg"
import "bar"
import "dialogue"
import "quicksettings"
import "hub"
import "launcher"
import "notifs"
import "osd"
import "cheatsheet"

ShellRoot {
    id: root

    // === Typography: Auto-load Slay the Princess fonts ===
    FontLoader { id: fontAmatic; source: "file:///home/arch/slaytheland/assets/fonts/AmaticSC-Regular.ttf" }
    FontLoader { id: fontAmaticBold; source: "file:///home/arch/slaytheland/assets/fonts/AmaticSC-Bold.ttf" }
    FontLoader { id: fontKelmscott; source: "file:///home/arch/slaytheland/assets/fonts/KelmscottRomanNF.ttf" }
    FontLoader { id: fontDokdo; source: "file:///home/arch/slaytheland/assets/fonts/EastSeaDokdo-Regular.ttf" }

    // === Global Shortcuts (Dispatched from Hyprland) ===
    GlobalShortcut {
        appid: "slay"
        name: "launcher"
        description: "Open the Slay the Princess app launcher"
        onPressed: ShellState.toggleLauncher()
    }

    GlobalShortcut {
        appid: "slay"
        name: "quicksettings"
        description: "Toggle the Quick Settings sidebar"
        onPressed: ShellState.toggleQuicksettings()
    }

    GlobalShortcut {
        appid: "slay"
        name: "hub"
        description: "Open the Slaytheland Customization Hub"
        onPressed: ShellState.toggleHub()
    }

    GlobalShortcut {
        appid: "slay"
        name: "princess"
        description: "Toggle the Princess companion desktop presence"
        onPressed: ShellState.toggleCompanion()
    }

    GlobalShortcut {
        appid: "slay"
        name: "vessel"
        description: "Cycle the Princess vessel"
        onPressed: RoomState.nextVessel()
    }

    GlobalShortcut {
        appid: "slay"
        name: "room"
        description: "Cycle the current room scene"
        onPressed: RoomState.nextRoom()
    }

    GlobalShortcut {
        appid: "slay"
        name: "dialogue"
        description: "Reveal a random context dialogue quote"
        onPressed: VoiceBus.triggerRandomQuote()
    }

    GlobalShortcut {
        appid: "slay"
        name: "cheatsheet"
        description: "Toggle the keybind grimoire cheatsheet"
        onPressed: ShellState.toggleCheatsheet()
    }

    Component.onCompleted: {
        VoiceBus.onStartup();
    }

    // === Per-Screen Surfaces ===
    Variants {
        model: ShellState.screens

        Scope {
            id: perScreen
            required property var modelData
            readonly property var st: ShellState.forScreen(modelData)

            // 1. Layered Parallax Background & Princess Companion
            PanelWindow {
                screen: perScreen.modelData
                anchors.top: true
                anchors.bottom: true
                anchors.left: true
                anchors.right: true
                exclusionMode: ExclusionMode.Ignore
                WlrLayershell.layer: WlrLayer.Background
                WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

                Bg {
                    screen: perScreen.modelData
                }
            }

            // 2. Top Floating Status Bar
            PanelWindow {
                id: barWindow
                screen: perScreen.modelData
                anchors.top: true
                anchors.left: true
                anchors.right: true
                implicitHeight: 56
                color: "transparent"
                WlrLayershell.layer: WlrLayer.Top
                WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

                Bar {
                    screen: perScreen.modelData
                }
            }

            // 3. Visual Novel Dialogue Box
            PanelWindow {
                id: dialogueWindow
                screen: perScreen.modelData
                anchors.bottom: true
                margins.bottom: 40
                implicitWidth: Math.min(840, perScreen.modelData.width - 40)
                implicitHeight: 220
                color: "transparent"
                exclusionMode: ExclusionMode.Ignore
                WlrLayershell.layer: WlrLayer.Overlay
                WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
                visible: true

                Box {}
            }

            // 4. Quick Settings Sidebar
            PanelWindow {
                id: qsWindow
                screen: perScreen.modelData
                anchors.top: true
                anchors.bottom: true
                anchors.left: true
                anchors.right: true
                color: "transparent"
                exclusionMode: ExclusionMode.Ignore
                WlrLayershell.layer: WlrLayer.Overlay
                WlrLayershell.keyboardFocus: perScreen.st && perScreen.st.quicksettingsOpen ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None
                visible: perScreen.st ? perScreen.st.quicksettingsOpen : false

                QuickSettingsSidebar {
                    screen: perScreen.modelData
                }
            }

            // 5. Application Launcher Modal
            PanelWindow {
                id: launcherWindow
                screen: perScreen.modelData
                anchors.top: true
                anchors.bottom: true
                anchors.left: true
                anchors.right: true
                color: "transparent"
                exclusionMode: ExclusionMode.Ignore
                WlrLayershell.layer: WlrLayer.Overlay
                WlrLayershell.keyboardFocus: perScreen.st && perScreen.st.launcherOpen ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None
                visible: perScreen.st ? perScreen.st.launcherOpen : false

                Launcher {
                    screen: perScreen.modelData
                }
            }

            // 6. Customization Settings Hub
            PanelWindow {
                id: hubWindow
                screen: perScreen.modelData
                anchors.top: true
                anchors.bottom: true
                anchors.left: true
                anchors.right: true
                color: "transparent"
                exclusionMode: ExclusionMode.Ignore
                WlrLayershell.layer: WlrLayer.Overlay
                WlrLayershell.keyboardFocus: perScreen.st && perScreen.st.hubOpen ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None
                visible: perScreen.st ? perScreen.st.hubOpen : false

                SettingsHub {
                    screen: perScreen.modelData
                }
            }

            // 7. Notification Toasts
            PanelWindow {
                id: notifsWindow
                screen: perScreen.modelData
                anchors.top: true
                anchors.right: true
                margins.top: 56
                margins.right: 16
                implicitWidth: 380
                implicitHeight: 500
                color: "transparent"
                exclusionMode: ExclusionMode.Ignore
                WlrLayershell.layer: WlrLayer.Overlay
                WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
                visible: Notifs.popups.length > 0

                Toasts {
                    screen: perScreen.modelData
                }
            }

            // 8. OSD HUD Popup
            PanelWindow {
                id: osdWindow
                screen: perScreen.modelData
                anchors.bottom: true
                margins.bottom: 120
                implicitWidth: 260
                implicitHeight: 110
                color: "transparent"
                exclusionMode: ExclusionMode.Ignore
                WlrLayershell.layer: WlrLayer.Overlay
                WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

                Osd {}
            }

            // 9. Keybind Grimoire Cheatsheet
            PanelWindow {
                id: cheatsheetWindow
                screen: perScreen.modelData
                anchors.top: true
                anchors.bottom: true
                anchors.left: true
                anchors.right: true
                color: "transparent"
                exclusionMode: ExclusionMode.Ignore
                WlrLayershell.layer: WlrLayer.Overlay
                WlrLayershell.keyboardFocus: perScreen.st && perScreen.st.cheatsheetOpen ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None
                visible: perScreen.st ? perScreen.st.cheatsheetOpen : false

                Cheatsheet {
                    screen: perScreen.modelData
                }
            }
        }
    }
}
