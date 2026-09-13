import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import ".."
import "../services"
import "../widgets"

Item {
    id: root

    required property var screen

    implicitHeight: 46
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    anchors.margins: 8

    // Status bar background frame
    Border {
        anchors.fill: parent
        borderMargin: 16
    }

    Rectangle {
        anchors.fill: parent
        anchors.margins: 4
        color: Qt.rgba(0.06, 0.05, 0.07, 0.85)
        radius: Theme.radiusSmall
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 12
        anchors.rightMargin: 12
        spacing: 12

        // === LEFT: Blade Launcher & Roman Workspaces ===
        RowLayout {
            spacing: 8

            // Blade Launcher Button
            Rectangle {
                width: 32
                height: 32
                radius: Theme.radiusSmall
                color: bladeMouse.containsMouse ? Theme.bloodDried : Theme.surfaceAlt
                border.color: bladeMouse.containsMouse ? Theme.crimson : Theme.graphiteMuted

                Text {
                    anchors.centerIn: parent
                    text: "🗡️"
                    font.pixelSize: 16
                }

                MouseArea {
                    id: bladeMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        Sfx.playBlade();
                        ShellState.toggleLauncher();
                    }
                }
            }

            // Roman Workspaces (I, II, III, IV, V)
            Row {
                id: wsRow
                spacing: 4

                readonly property var numerals: ["I", "II", "III", "IV", "V"]

                Repeater {
                    model: 5

                    Rectangle {
                        id: wsChip
                        required property int index
                        property int wsId: index + 1
                        property bool isActive: Hyprland.focusedWorkspace && Hyprland.focusedWorkspace.id === wsId

                        width: 28
                        height: 28
                        radius: Theme.radiusSmall
                        color: isActive ? Theme.accent : (wsMouse.containsMouse ? Theme.surfaceHover : "transparent")
                        border.color: isActive ? Theme.accent : Theme.graphiteMuted
                        border.width: isActive ? 2 : 1

                        Text {
                            anchors.centerIn: parent
                            text: wsRow.numerals[wsChip.index]
                            color: wsChip.isActive ? Theme.parchmentWhite : (wsMouse.containsMouse ? Theme.parchment : Theme.pencilLight)
                            font.family: Theme.fontTitle
                            font.pixelSize: 15
                            font.bold: wsChip.isActive
                        }

                        // Blood-red active indicator line
                        Rectangle {
                            anchors.bottom: parent.bottom
                            anchors.left: parent.left
                            anchors.right: parent.right
                            height: 2
                            color: Theme.crimsonVivid
                            visible: wsChip.isActive
                        }

                        MouseArea {
                            id: wsMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                Sfx.playFootstep();
                                Hyprland.dispatch("workspace " + wsChip.wsId);
                                if (wsChip.wsId === 1) {
                                    VoiceBus.onWorkspaceHero();
                                }
                            }
                        }
                    }
                }
            }
        }

        // === CENTER: Active Window Title ===
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Text {
                anchors.centerIn: parent
                width: Math.min(parent.width - 20, implicitWidth)
                elide: Text.ElideRight
                horizontalAlignment: Text.AlignHCenter
                text: Hyprland.activeWindow && Hyprland.activeWindow.title !== ""
                      ? Hyprland.activeWindow.title
                      : "Slay the Princess · The Cabin Awaits"
                color: Theme.parchment
                font.family: Theme.fontBody
                font.pixelSize: 22
                font.bold: true
            }
        }

        // === RIGHT: Vessel, Audio, Clock, Battery, QuickSettings ===
        RowLayout {
            spacing: 10

            // Current Princess Vessel Chip
            Rectangle {
                height: 30
                implicitWidth: vesselLabel.implicitWidth + 24
                radius: Theme.radiusSmall
                color: vesselMouse.containsMouse ? Theme.surfaceHover : Theme.surfaceAlt
                border.color: Theme.bloodDried

                Row {
                    anchors.centerIn: parent
                    spacing: 6

                    Text {
                        text: "👑"
                        font.pixelSize: 13
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        id: vesselLabel
                        text: RoomState.currentVessel.name
                        color: Theme.parchmentWhite
                        font.family: Theme.fontTitle
                        font.pixelSize: 14
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                MouseArea {
                    id: vesselMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        Sfx.playBlade();
                        RoomState.nextVessel();
                    }
                }
            }

            // Voice Mute Toggle
            Rectangle {
                width: 28
                height: 28
                radius: Theme.radiusSmall
                color: VoiceBus.voiceMuted ? Theme.bloodDried : Theme.surfaceAlt
                border.color: Theme.graphiteMuted

                Text {
                    anchors.centerIn: parent
                    text: VoiceBus.voiceMuted ? "🔇" : "🎙️"
                    font.pixelSize: 14
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        VoiceBus.voiceMuted = !VoiceBus.voiceMuted;
                        Sfx.playButton();
                    }
                }
            }

            // Volume Blade Widget
            Rectangle {
                height: 28
                implicitWidth: volText.implicitWidth + 28
                radius: Theme.radiusSmall
                color: Theme.surfaceAlt
                border.color: Theme.graphiteMuted

                Row {
                    anchors.centerIn: parent
                    spacing: 4

                    Text {
                        text: Audio.muted ? "🔇" : "🗡️"
                        font.pixelSize: 13
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        id: volText
                        text: Math.round(Audio.volume * 100) + "%"
                        color: Theme.parchment
                        font.family: Theme.fontBody
                        font.pixelSize: 18
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        Sfx.playGlass();
                        Audio.toggleMute();
                    }
                    onWheel: function(wheel) {
                        if (wheel.angleDelta.y > 0) {
                            Audio.setVolume(Audio.volume + 0.05);
                        } else {
                            Audio.setVolume(Audio.volume - 0.05);
                        }
                    }
                }
            }

            // Battery Pill (if present)
            Rectangle {
                visible: Battery.present
                height: 28
                implicitWidth: batLabel.implicitWidth + 24
                radius: Theme.radiusSmall
                color: Battery.low ? Theme.bloodDried : Theme.surfaceAlt
                border.color: Battery.low ? Theme.crimsonVivid : Theme.graphiteMuted

                Row {
                    anchors.centerIn: parent
                    spacing: 4

                    Text {
                        text: Battery.charging ? "⚡" : "🔋"
                        font.pixelSize: 13
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        id: batLabel
                        text: Battery.pct + "%"
                        color: Battery.low ? Theme.crimsonVivid : Theme.parchment
                        font.family: Theme.fontBody
                        font.pixelSize: 18
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }

            // Kelmscott Clock
            Rectangle {
                height: 30
                implicitWidth: clockText.implicitWidth + 18
                radius: Theme.radiusSmall
                color: Theme.surfaceAlt
                border.color: Theme.graphiteMuted

                Text {
                    id: clockText
                    anchors.centerIn: parent
                    text: Qt.formatDateTime(new Date(), "ddd, MMM d · hh:mm")
                    color: Theme.parchmentWhite
                    font.family: Theme.fontTitle
                    font.pixelSize: 15
                }

                Timer {
                    interval: 1000
                    running: true
                    repeat: true
                    onTriggered: clockText.text = Qt.formatDateTime(new Date(), "ddd, MMM d · hh:mm")
                }
            }

            // Quick Settings Cog / Choice Trigger
            Rectangle {
                width: 32
                height: 32
                radius: Theme.radiusSmall
                color: qsMouse.containsMouse ? Theme.surfaceHover : Theme.surfaceAlt
                border.color: qsMouse.containsMouse ? Theme.crimson : Theme.graphiteMuted

                Text {
                    anchors.centerIn: parent
                    text: "⚙️"
                    font.pixelSize: 15
                }

                MouseArea {
                    id: qsMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        Sfx.playButton();
                        ShellState.toggleQuicksettings();
                    }
                }
            }
        }
    }
}
