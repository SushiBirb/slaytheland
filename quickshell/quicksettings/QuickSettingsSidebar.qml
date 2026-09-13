import QtQuick
import QtQuick.Layouts
import ".."
import "../services"
import "../widgets"
import "../data/vessels.js" as VesselsData
import "../data/rooms.js" as RoomsData

Item {
    id: root

    required property var screen

    readonly property var stateSlice: ShellState.forScreen(screen)
    readonly property bool isOpen: stateSlice ? stateSlice.quicksettingsOpen : false

    anchors.fill: parent
    visible: panel.x < root.width

    property int activeTab: 0 // 0: Quick Controls, 1: Cabin Studio

    // Dimmed background overlay
    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0.45)
        opacity: root.isOpen ? 1.0 : 0.0
        Behavior on opacity { NumberAnimation { duration: 250 } }

        MouseArea {
            anchors.fill: parent
            onClicked: ShellState.toggleQuicksettings()
        }
    }

    // Right sliding panel
    Item {
        id: panel
        width: 360
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.topMargin: 10
        anchors.bottomMargin: 10

        x: root.isOpen ? (root.width - width - 10) : (root.width + 10)
        Behavior on x { NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }

        Border {
            anchors.fill: parent
            borderMargin: 24
        }

        Rectangle {
            anchors.fill: parent
            anchors.margins: 6
            color: Qt.rgba(0.08, 0.07, 0.09, 0.96)
            radius: Theme.radiusSmall
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 18
            spacing: 12

            // 1. Ryoku Header: Clock, Date, Battery Pill & Quick Power Icons
            RowLayout {
                Layout.fillWidth: true

                Column {
                    Layout.fillWidth: true
                    spacing: 2

                    Text {
                        text: Qt.formatDateTime(new Date(), "hh:mm")
                        color: Theme.parchmentWhite
                        font.family: Theme.fontTitle
                        font.pixelSize: 32
                        font.bold: true
                    }

                    Row {
                        spacing: 6
                        Text {
                            text: Qt.formatDateTime(new Date(), "dddd, MMM d")
                            color: Theme.pencilLight
                            font.family: Theme.fontBody
                            font.pixelSize: 17
                        }

                        // Battery Pill (Ryoku pattern)
                        Rectangle {
                            visible: Battery.present
                            width: batteryRow.implicitWidth + 12
                            height: 20
                            radius: 10
                            color: Theme.surfaceAlt
                            border.color: Battery.low ? Theme.crimsonVivid : Theme.graphiteMuted

                            Row {
                                id: batteryRow
                                anchors.centerIn: parent
                                spacing: 3
                                GlyphIcon {
                                    width: 10
                                    height: 10
                                    name: Battery.charging ? "bolt" : "battery"
                                    color: Battery.low ? Theme.crimsonVivid : Theme.parchment
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                                Text {
                                    text: Battery.pct + "%"
                                    color: Battery.low ? Theme.crimsonVivid : Theme.parchment
                                    font.family: Theme.fontTitle
                                    font.pixelSize: 11
                                }
                            }
                        }
                    }
                }

                // Header Action Icons
                Row {
                    spacing: 4

                    // Close / Dismiss
                    Rectangle {
                        width: 30
                        height: 30
                        radius: Theme.radiusSmall
                        color: Theme.surfaceAlt
                        border.color: Theme.graphiteMuted

                        Text {
                            anchors.centerIn: parent
                            text: "✕"
                            color: Theme.parchment
                            font.pixelSize: 13
                        }
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: ShellState.toggleQuicksettings()
                        }
                    }
                }
            }

            // 2. Segment Switcher (Ryoku pattern)
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 34
                radius: Theme.radiusSmall
                color: Theme.voidBlack
                border.color: Theme.graphiteMuted

                Row {
                    anchors.fill: parent
                    anchors.margins: 2
                    spacing: 2

                    Rectangle {
                        width: (parent.width - 2) / 2
                        height: parent.height
                        radius: Theme.radiusSmall
                        color: root.activeTab === 0 ? Theme.surfaceSelected : "transparent"
                        border.color: root.activeTab === 0 ? Theme.accent : "transparent"

                        Text {
                            anchors.centerIn: parent
                            text: "QUICK CONTROLS"
                            color: root.activeTab === 0 ? Theme.parchmentWhite : Theme.pencilLight
                            font.family: Theme.fontTitle
                            font.pixelSize: 12
                            font.bold: root.activeTab === 0
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root.activeTab = 0
                        }
                    }

                    Rectangle {
                        width: (parent.width - 2) / 2
                        height: parent.height
                        radius: Theme.radiusSmall
                        color: root.activeTab === 1 ? Theme.surfaceSelected : "transparent"
                        border.color: root.activeTab === 1 ? Theme.accent : "transparent"

                        Text {
                            anchors.centerIn: parent
                            text: "CABIN STUDIO"
                            color: root.activeTab === 1 ? Theme.parchmentWhite : Theme.pencilLight
                            font.family: Theme.fontTitle
                            font.pixelSize: 12
                            font.bold: root.activeTab === 1
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root.activeTab = 1
                        }
                    }
                }
            }

            // 3. Scrollable Content Area
            Flickable {
                Layout.fillWidth: true
                Layout.fillHeight: true
                contentWidth: width
                contentHeight: root.activeTab === 0 ? quickContent.implicitHeight : studioContent.implicitHeight
                clip: true
                boundsBehavior: Flickable.StopAtBounds

                // TAB 0: QUICK CONTROLS
                Column {
                    id: quickContent
                    visible: root.activeTab === 0
                    width: parent.width
                    spacing: 12

                    // Hardware Toggles
                    QuickSettingsTiles {
                        width: parent.width
                    }

                    Rectangle {
                        width: parent.width
                        height: 1
                        color: Theme.graphiteMuted
                    }

                    // Sliders
                    SlaySlider {
                        width: parent.width
                        label: "Master Audio"
                        icon: "speaker"
                        value: Audio.volume
                        from: 0.0
                        to: 1.0
                        onValueModified: function(val) { Audio.setVolume(val); }
                    }

                    SlaySlider {
                        width: parent.width
                        label: "Microphone"
                        icon: "mic"
                        value: Audio.inputVolume
                        from: 0.0
                        to: 1.0
                        onValueModified: function(val) { Audio.setInputVolume(val); }
                    }

                    Rectangle {
                        width: parent.width
                        height: 1
                        color: Theme.graphiteMuted
                    }

                    // MediaHero Card (Colin Stetson OST & MPRIS)
                    Rectangle {
                        width: parent.width
                        height: 72
                        radius: Theme.radiusSmall
                        color: Theme.surfaceAlt
                        border.color: Theme.accentMuted

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 10
                            spacing: 10

                            Rectangle {
                                width: 48
                                height: 48
                                radius: 4
                                color: Theme.voidBlack
                                border.color: Theme.graphiteMuted

                                GlyphIcon {
                                    anchors.centerIn: parent
                                    width: 22
                                    height: 22
                                    name: "music"
                                    color: Theme.parchment
                                }
                            }

                            Column {
                                Layout.fillWidth: true
                                spacing: 2

                                Text {
                                    text: Music.displayTitle
                                    color: Theme.parchmentWhite
                                    font.family: Theme.fontTitle
                                    font.pixelSize: 14
                                    font.bold: true
                                    elide: Text.ElideRight
                                    width: 170
                                }

                                Text {
                                    text: Music.displayArtist
                                    color: Theme.pencilLight
                                    font.family: Theme.fontBody
                                    font.pixelSize: 16
                                    elide: Text.ElideRight
                                    width: 170
                                }
                            }

                            Row {
                                spacing: 4

                                Rectangle {
                                    width: 32
                                    height: 32
                                    radius: Theme.radiusSmall
                                    color: Theme.surfaceHover
                                    border.color: Theme.graphiteMuted

                                    GlyphIcon {
                                        anchors.centerIn: parent
                                        width: 12
                                        height: 12
                                        name: "prev"
                                        color: Theme.parchment
                                    }
                                    MouseArea {
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: { Sfx.playButton(); Music.prevTrack(); }
                                    }
                                }

                                Rectangle {
                                    width: 32
                                    height: 32
                                    radius: Theme.radiusSmall
                                    color: Theme.accentMuted
                                    border.color: Theme.accent

                                    GlyphIcon {
                                        anchors.centerIn: parent
                                        width: 12
                                        height: 12
                                        name: Music.isPlaying ? "pause" : "play"
                                        color: Theme.parchmentWhite
                                    }
                                    MouseArea {
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: { Sfx.playButton(); Music.togglePlay(); }
                                    }
                                }

                                Rectangle {
                                    width: 32
                                    height: 32
                                    radius: Theme.radiusSmall
                                    color: Theme.surfaceHover
                                    border.color: Theme.graphiteMuted

                                    GlyphIcon {
                                        anchors.centerIn: parent
                                        width: 12
                                        height: 12
                                        name: "next"
                                        color: Theme.parchment
                                    }
                                    MouseArea {
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: { Sfx.playButton(); Music.nextTrack(); }
                                    }
                                }
                            }
                        }
                    }

                    Rectangle {
                        width: parent.width
                        height: 1
                        color: Theme.graphiteMuted
                    }

                    // Power Choices (Slay the Princess themed)
                    PowerChoices {
                        width: parent.width
                    }
                }

                // TAB 1: CABIN STUDIO
                Column {
                    id: studioContent
                    visible: root.activeTab === 1
                    width: parent.width
                    spacing: 12

                    Text {
                        text: "Princess Vessel"
                        color: Theme.parchmentWhite
                        font.family: Theme.fontTitle
                        font.pixelSize: 16
                    }

                    Rectangle {
                        width: parent.width
                        height: 48
                        radius: Theme.radiusSmall
                        color: Theme.surfaceAlt
                        border.color: Theme.accent

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 10
                            spacing: 8

                            GlyphIcon {
                                width: 16
                                height: 16
                                name: "crown"
                                color: Theme.parchmentWhite
                            }
                            Column {
                                Layout.fillWidth: true
                                Text {
                                    text: RoomState.currentVessel ? RoomState.currentVessel.name : "The Princess"
                                    color: Theme.parchmentWhite
                                    font.family: Theme.fontTitle
                                    font.pixelSize: 14
                                    font.bold: true
                                }
                                Text {
                                    text: RoomState.currentVessel ? RoomState.currentVessel.title : "Chapter I"
                                    color: Theme.pencilLight
                                    font.family: Theme.fontBody
                                    font.pixelSize: 14
                                }
                            }

                            CharcoalButton {
                                text: "Cycle"
                                fontSize: 14
                                implicitWidth: 64
                                implicitHeight: 28
                                onClicked: RoomState.nextVessel()
                            }
                        }
                    }

                    Text {
                        text: "Cabin Room Scene"
                        color: Theme.parchmentWhite
                        font.family: Theme.fontTitle
                        font.pixelSize: 16
                    }

                    Rectangle {
                        width: parent.width
                        height: 48
                        radius: Theme.radiusSmall
                        color: Theme.surfaceAlt
                        border.color: Theme.graphiteMuted

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 10
                            spacing: 8

                            GlyphIcon {
                                width: 16
                                height: 16
                                name: "tree"
                                color: Theme.parchmentWhite
                            }
                            Column {
                                Layout.fillWidth: true
                                Text {
                                    text: RoomState.currentRoom ? RoomState.currentRoom.name : "The Woods"
                                    color: Theme.parchmentWhite
                                    font.family: Theme.fontTitle
                                    font.pixelSize: 14
                                    font.bold: true
                                }
                                Text {
                                    text: RoomState.currentRoom ? RoomState.currentRoom.description : ""
                                    color: Theme.pencilLight
                                    font.family: Theme.fontBody
                                    font.pixelSize: 13
                                    elide: Text.ElideRight
                                    width: 170
                                }
                            }

                            CharcoalButton {
                                text: "Cycle"
                                fontSize: 14
                                implicitWidth: 64
                                implicitHeight: 28
                                onClicked: RoomState.nextRoom()
                            }
                        }
                    }

                    Rectangle {
                        width: parent.width
                        height: 1
                        color: Theme.graphiteMuted
                    }

                    // Shaders
                    Text {
                        text: "Living Pencil Shaders"
                        color: Theme.parchmentWhite
                        font.family: Theme.fontTitle
                        font.pixelSize: 16
                    }

                    SlaySlider {
                        width: parent.width
                        label: "Boil Intensity"
                        icon: "pencil"
                        value: RoomState.shaderIntensity
                        from: 0.0
                        to: 1.0
                        onValueModified: function(val) { RoomState.shaderIntensity = val; }
                    }

                    SlaySlider {
                        width: parent.width
                        label: "Vignette Darkening"
                        icon: "moon"
                        value: RoomState.vignetteIntensity
                        from: 0.0
                        to: 1.0
                        onValueModified: function(val) { RoomState.vignetteIntensity = val; }
                    }

                    CharcoalButton {
                        width: parent.width
                        text: "Open Full Settings Hub (SUPER+,)"
                        fontSize: 16
                        isChoice: true
                        onClicked: {
                            ShellState.toggleQuicksettings();
                            ShellState.toggleHub();
                        }
                    }
                }
            }
        }
    }
}
