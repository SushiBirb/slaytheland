import QtQuick
import QtQuick.Layouts
import ".."
import "../services"

Item {
    id: root

    implicitWidth: 280
    implicitHeight: 140

    property bool wifiEnabled: true
    property bool btEnabled: false
    property bool nightLightEnabled: false

    GridLayout {
        anchors.fill: parent
        columns: 2
        rowSpacing: 8
        columnSpacing: 8

        // Companion Tile
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: Theme.radiusSmall
            color: ShellState.forActive() && ShellState.forActive().companionVisible ? Theme.bloodDried : Theme.surfaceAlt
            border.color: ShellState.forActive() && ShellState.forActive().companionVisible ? Theme.crimson : Theme.graphiteMuted

            Row {
                anchors.centerIn: parent
                spacing: 8
                Text { text: "👑"; font.pixelSize: 16 }
                Text {
                    text: "Princess"
                    color: Theme.parchment
                    font.family: Theme.fontBody
                    font.pixelSize: 20
                    font.bold: true
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    Sfx.playButton();
                    ShellState.toggleCompanion();
                }
            }
        }

        // Voice Quips Tile
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: Theme.radiusSmall
            color: !VoiceBus.voiceMuted ? Theme.bloodDried : Theme.surfaceAlt
            border.color: !VoiceBus.voiceMuted ? Theme.crimson : Theme.graphiteMuted

            Row {
                anchors.centerIn: parent
                spacing: 8
                Text { text: VoiceBus.voiceMuted ? "🔇" : "🎙️"; font.pixelSize: 16 }
                Text {
                    text: "Voice Quips"
                    color: Theme.parchment
                    font.family: Theme.fontBody
                    font.pixelSize: 20
                    font.bold: true
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    Sfx.playButton();
                    VoiceBus.voiceMuted = !VoiceBus.voiceMuted;
                }
            }
        }

        // Night Light / Candlelight Tile
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: Theme.radiusSmall
            color: root.nightLightEnabled ? Theme.bloodDried : Theme.surfaceAlt
            border.color: root.nightLightEnabled ? Theme.amber : Theme.graphiteMuted

            Row {
                anchors.centerIn: parent
                spacing: 8
                Text { text: "🕯️"; font.pixelSize: 16 }
                Text {
                    text: "Candlelight"
                    color: Theme.parchment
                    font.family: Theme.fontBody
                    font.pixelSize: 20
                    font.bold: true
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    Sfx.playButton();
                    root.nightLightEnabled = !root.nightLightEnabled;
                }
            }
        }

        // Do Not Disturb Tile
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: Theme.radiusSmall
            color: Notifs.dnd ? Theme.bloodDried : Theme.surfaceAlt
            border.color: Notifs.dnd ? Theme.crimson : Theme.graphiteMuted

            Row {
                anchors.centerIn: parent
                spacing: 8
                Text { text: "🌙"; font.pixelSize: 16 }
                Text {
                    text: "Do Not Disturb"
                    color: Theme.parchment
                    font.family: Theme.fontBody
                    font.pixelSize: 20
                    font.bold: true
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    Sfx.playButton();
                    Notifs.dnd = !Notifs.dnd;
                }
            }
        }
    }
}
