import QtQuick
import QtQuick.Layouts
import ".."
import "../services"
import "../widgets"

Item {
    id: root

    implicitWidth: 320
    implicitHeight: 220

    property bool wifiEnabled: true
    property bool btEnabled: true
    property bool nightLightEnabled: false
    property bool keepAwakeEnabled: false

    GridLayout {
        anchors.fill: parent
        columns: 2
        rowSpacing: 8
        columnSpacing: 8

        // 1. Wi-Fi Tile
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 50
            radius: Theme.radiusSmall
            color: root.wifiEnabled ? Theme.surfaceHover : Theme.surfaceAlt
            border.color: root.wifiEnabled ? Theme.accent : Theme.graphiteMuted
            border.width: root.wifiEnabled ? 2 : 1

            RowLayout {
                anchors.fill: parent
                anchors.margins: 8
                spacing: 8

                GlyphIcon {
                    width: 18
                    height: 18
                    name: "wifi"
                    color: root.wifiEnabled ? Theme.parchmentWhite : Theme.pencilLight
                }
                Column {
                    Layout.fillWidth: true
                    spacing: 1
                    Text { text: "Wi-Fi"; color: Theme.parchmentWhite; font.family: Theme.fontBody; font.pixelSize: 18; font.bold: true }
                    Text { text: root.wifiEnabled ? "Connected" : "Disconnected"; color: Theme.pencilLight; font.family: Theme.fontBody; font.pixelSize: 13 }
                }
            }
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    Sfx.playButton();
                    root.wifiEnabled = !root.wifiEnabled;
                }
            }
        }

        // 2. Bluetooth Tile
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 50
            radius: Theme.radiusSmall
            color: root.btEnabled ? Theme.surfaceHover : Theme.surfaceAlt
            border.color: root.btEnabled ? Theme.accent : Theme.graphiteMuted
            border.width: root.btEnabled ? 2 : 1

            RowLayout {
                anchors.fill: parent
                anchors.margins: 8
                spacing: 8

                GlyphIcon {
                    width: 18
                    height: 18
                    name: "bluetooth"
                    color: root.btEnabled ? Theme.parchmentWhite : Theme.pencilLight
                }
                Column {
                    Layout.fillWidth: true
                    spacing: 1
                    Text { text: "Bluetooth"; color: Theme.parchmentWhite; font.family: Theme.fontBody; font.pixelSize: 18; font.bold: true }
                    Text { text: root.btEnabled ? "Enabled" : "Disabled"; color: Theme.pencilLight; font.family: Theme.fontBody; font.pixelSize: 13 }
                }
            }
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    Sfx.playButton();
                    root.btEnabled = !root.btEnabled;
                }
            }
        }

        // 3. Princess Companion Tile
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 50
            radius: Theme.radiusSmall
            readonly property bool visibleOnDesk: ShellState.forActive() && ShellState.forActive().companionVisible
            color: visibleOnDesk ? Theme.surfaceHover : Theme.surfaceAlt
            border.color: visibleOnDesk ? Theme.accent : Theme.graphiteMuted
            border.width: visibleOnDesk ? 2 : 1

            RowLayout {
                anchors.fill: parent
                anchors.margins: 8
                spacing: 8

                GlyphIcon {
                    width: 18
                    height: 18
                    name: "crown"
                    color: Theme.parchmentWhite
                }
                Column {
                    Layout.fillWidth: true
                    spacing: 1
                    Text { text: "Princess"; color: Theme.parchmentWhite; font.family: Theme.fontBody; font.pixelSize: 18; font.bold: true }
                    Text { text: parent.parent.parent.visibleOnDesk ? "At Your Side" : "In Basement"; color: Theme.pencilLight; font.family: Theme.fontBody; font.pixelSize: 13 }
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

        // 4. Voice Quips Tile
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 50
            radius: Theme.radiusSmall
            color: !VoiceBus.voiceMuted ? Theme.surfaceHover : Theme.surfaceAlt
            border.color: !VoiceBus.voiceMuted ? Theme.accent : Theme.graphiteMuted
            border.width: !VoiceBus.voiceMuted ? 2 : 1

            RowLayout {
                anchors.fill: parent
                anchors.margins: 8
                spacing: 8

                GlyphIcon {
                    width: 18
                    height: 18
                    name: VoiceBus.voiceMuted ? "mic-off" : "mic"
                    color: VoiceBus.voiceMuted ? Theme.crimsonVivid : Theme.parchmentWhite
                }
                Column {
                    Layout.fillWidth: true
                    spacing: 1
                    Text { text: "Narrator"; color: Theme.parchmentWhite; font.family: Theme.fontBody; font.pixelSize: 18; font.bold: true }
                    Text { text: VoiceBus.voiceMuted ? "Muted" : "Jonathan Sims"; color: Theme.pencilLight; font.family: Theme.fontBody; font.pixelSize: 13 }
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

        // 5. Candlelight / Night Light
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 50
            radius: Theme.radiusSmall
            color: root.nightLightEnabled ? Theme.surfaceHover : Theme.surfaceAlt
            border.color: root.nightLightEnabled ? Theme.amber : Theme.graphiteMuted
            border.width: root.nightLightEnabled ? 2 : 1

            RowLayout {
                anchors.fill: parent
                anchors.margins: 8
                spacing: 8

                GlyphIcon {
                    width: 18
                    height: 18
                    name: "candle"
                    color: root.nightLightEnabled ? Theme.amber : Theme.pencilLight
                }
                Column {
                    Layout.fillWidth: true
                    spacing: 1
                    Text { text: "Candlelight"; color: Theme.parchmentWhite; font.family: Theme.fontBody; font.pixelSize: 18; font.bold: true }
                    Text { text: root.nightLightEnabled ? "Warm 3200K" : "Natural"; color: Theme.pencilLight; font.family: Theme.fontBody; font.pixelSize: 13 }
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

        // 6. Do Not Disturb
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 50
            radius: Theme.radiusSmall
            color: Notifs.dnd ? Theme.surfaceHover : Theme.surfaceAlt
            border.color: Notifs.dnd ? Theme.accent : Theme.graphiteMuted
            border.width: Notifs.dnd ? 2 : 1

            RowLayout {
                anchors.fill: parent
                anchors.margins: 8
                spacing: 8

                GlyphIcon {
                    width: 18
                    height: 18
                    name: "moon"
                    color: Notifs.dnd ? Theme.crimsonVivid : Theme.pencilLight
                }
                Column {
                    Layout.fillWidth: true
                    spacing: 1
                    Text { text: "Do Not Disturb"; color: Theme.parchmentWhite; font.family: Theme.fontBody; font.pixelSize: 18; font.bold: true }
                    Text { text: Notifs.dnd ? "Silence" : "Receiving"; color: Theme.pencilLight; font.family: Theme.fontBody; font.pixelSize: 13 }
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

        // 7. Keep Awake Tile
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 50
            radius: Theme.radiusSmall
            color: root.keepAwakeEnabled ? Theme.surfaceHover : Theme.surfaceAlt
            border.color: root.keepAwakeEnabled ? Theme.accent : Theme.graphiteMuted
            border.width: root.keepAwakeEnabled ? 2 : 1

            RowLayout {
                anchors.fill: parent
                anchors.margins: 8
                spacing: 8

                GlyphIcon {
                    width: 18
                    height: 18
                    name: "coffee"
                    color: root.keepAwakeEnabled ? Theme.parchmentWhite : Theme.pencilLight
                }
                Column {
                    Layout.fillWidth: true
                    spacing: 1
                    Text { text: "Keep Awake"; color: Theme.parchmentWhite; font.family: Theme.fontBody; font.pixelSize: 18; font.bold: true }
                    Text { text: root.keepAwakeEnabled ? "Inhibited" : "Auto Sleep"; color: Theme.pencilLight; font.family: Theme.fontBody; font.pixelSize: 13 }
                }
            }
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    Sfx.playButton();
                    root.keepAwakeEnabled = !root.keepAwakeEnabled;
                }
            }
        }

        // 8. Pencil Boil Shader Toggle
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 50
            radius: Theme.radiusSmall
            color: RoomState.shaderEnabled ? Theme.surfaceHover : Theme.surfaceAlt
            border.color: RoomState.shaderEnabled ? Theme.accent : Theme.graphiteMuted
            border.width: RoomState.shaderEnabled ? 2 : 1

            RowLayout {
                anchors.fill: parent
                anchors.margins: 8
                spacing: 8

                GlyphIcon {
                    width: 18
                    height: 18
                    name: "pencil"
                    color: RoomState.shaderEnabled ? Theme.parchmentWhite : Theme.pencilLight
                }
                Column {
                    Layout.fillWidth: true
                    spacing: 1
                    Text { text: "Pencil Boil"; color: Theme.parchmentWhite; font.family: Theme.fontBody; font.pixelSize: 18; font.bold: true }
                    Text { text: RoomState.shaderEnabled ? "12 FPS Boil" : "Static Art"; color: Theme.pencilLight; font.family: Theme.fontBody; font.pixelSize: 13 }
                }
            }
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    Sfx.playButton();
                    RoomState.shaderEnabled = !RoomState.shaderEnabled;
                }
            }
        }
    }
}
