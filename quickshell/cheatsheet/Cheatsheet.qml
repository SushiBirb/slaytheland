import QtQuick
import QtQuick.Layouts
import ".."
import "../services"
import "../widgets"

Item {
    id: root

    required property var screen

    readonly property var stateSlice: ShellState.forScreen(screen)
    readonly property bool isOpen: stateSlice ? stateSlice.cheatsheetOpen : false

    anchors.fill: parent
    visible: opacity > 0.0
    opacity: root.isOpen ? 1.0 : 0.0
    Behavior on opacity { NumberAnimation { duration: 220 } }

    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(0.04, 0.03, 0.05, 0.85)

        MouseArea {
            anchors.fill: parent
            onClicked: ShellState.toggleCheatsheet()
        }
    }

    Item {
        id: card
        width: Math.min(680, parent.width - 40)
        height: Math.min(600, parent.height - 40)
        anchors.centerIn: parent

        Border {
            anchors.fill: parent
            borderMargin: 24
        }

        Rectangle {
            anchors.fill: parent
            anchors.margins: 6
            color: Theme.charcoal
            radius: Theme.radiusMedium
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 24
            spacing: 16

            RowLayout {
                Layout.fillWidth: true

                Text {
                    text: "Slaytheland Keybind Grimoire"
                    color: Theme.parchmentWhite
                    font.family: Theme.fontTitle
                    font.pixelSize: 24
                    font.bold: true
                }

                Item { Layout.fillWidth: true }

                Rectangle {
                    width: 28
                    height: 28
                    radius: Theme.radiusSmall
                    color: Theme.surfaceAlt
                    border.color: Theme.graphiteMuted

                    Text {
                        anchors.centerIn: parent
                        text: "✕"
                        color: Theme.parchment
                        font.pixelSize: 14
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: ShellState.toggleCheatsheet()
                    }
                }
            }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 1
                    color: Theme.bloodDried
                }

                ListView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    spacing: 8

                    model: [
                        { chord: "SUPER + Return", desc: "Launch Kitty Terminal (Charcoal & Parchment)", group: "Apps" },
                        { chord: "SUPER + Space", desc: "Open Slay the Princess App Launcher", group: "Shell" },
                        { chord: "SUPER + Escape", desc: "Toggle Quick Settings Sidebar (Audio, Power, Toggles)", group: "Shell" },
                        { chord: "SUPER + comma", desc: "Open Slaytheland Customization Hub (Vessels, Rooms)", group: "Customization" },
                        { chord: "SUPER + Q", desc: "Close Active Window (killactive)", group: "Windows" },
                        { chord: "SUPER + W", desc: "Crossfade Sky / CG Wallpaper Layer", group: "Atmosphere" },
                        { chord: "SUPER + R", desc: "Cycle Room Scene (Woods -> Cabin -> Basement -> Mirror)", group: "Atmosphere" },
                        { chord: "SUPER + G", desc: "Toggle Princess Companion Desktop Presence", group: "Companion" },
                        { chord: "SUPER + X", desc: "Visual Novel Dialogue Quote with Audio Loop", group: "Dialogue" },
                        { chord: "SUPER + S", desc: "Toggle Scratchpad Special Workspace", group: "Workspaces" },
                        { chord: "SUPER + K", desc: "Toggle Keybind Grimoire (This Cheatsheet)", group: "Help" },
                        { chord: "SUPER + F", desc: "Toggle Fullscreen Window", group: "Windows" },
                        { chord: "SUPER + 1..5", desc: "Switch to Workspace I, II, III, IV, or V", group: "Workspaces" },
                        { chord: "SUPER + L", desc: "Lock Screen with Slay the Princess Hyprlock", group: "Session" },
                        { chord: "XF86AudioRaise/Lower", desc: "Adjust Volume with Blade Unsheathing SFX", group: "Audio" },
                        { chord: "XF86AudioMute", desc: "Mute Sound with Glass Shatter SFX", group: "Audio" }
                    ]

                    delegate: Rectangle {
                        id: delegateRoot
                        required property var modelData
                        width: parent.width
                        height: 38
                        radius: Theme.radiusSmall
                        color: Theme.surfaceAlt
                        border.color: Theme.graphiteMuted

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 8
                            spacing: 12

                            Rectangle {
                                Layout.preferredHeight: 24
                                Layout.preferredWidth: chordText.implicitWidth + 14
                                radius: 4
                                color: Theme.voidBlack
                                border.color: Theme.crimson

                                Text {
                                    id: chordText
                                    anchors.centerIn: parent
                                    text: delegateRoot.modelData.chord
                                    color: Theme.parchmentWhite
                                    font.family: Theme.fontTitle
                                    font.pixelSize: 13
                                    font.bold: true
                                }
                            }

                            Text {
                                text: delegateRoot.modelData.desc
                                color: Theme.parchment
                                font.family: Theme.fontBody
                                font.pixelSize: 15
                                Layout.fillWidth: true
                                elide: Text.ElideRight
                            }

                            Text {
                                text: delegateRoot.modelData.group
                                color: Theme.pencilLight
                                font.family: Theme.fontTitle
                                font.pixelSize: 12
                            }
                        }
                    }
                }
        }
    }
}
