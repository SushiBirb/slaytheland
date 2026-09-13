import QtQuick
import QtQuick.Layouts
import ".."
import "../services"
import "../widgets"
import "../quicksettings"
import "../data/vessels.js" as VesselsData
import "../data/rooms.js" as RoomsData

Item {
    id: root

    required property var screen

    readonly property var stateSlice: ShellState.forScreen(screen)
    readonly property bool isOpen: stateSlice ? stateSlice.hubOpen : false

    anchors.fill: parent
    visible: opacity > 0.0
    opacity: root.isOpen ? 1.0 : 0.0
    Behavior on opacity { NumberAnimation { duration: 250 } }

    property int currentTab: 0 // 0: Sanctuary, 1: Scenery, 2: Shaders, 3: Audio

    // Backdrop with dark blur
    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(0.04, 0.03, 0.05, 0.90)

        MouseArea {
            anchors.fill: parent
            onClicked: ShellState.toggleHub()
        }
    }

    // Centered Modal Window
    Item {
        id: hubContainer
        width: Math.min(1000, parent.width - 60)
        height: Math.min(680, parent.height - 60)
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

            // Header Bar
            RowLayout {
                Layout.fillWidth: true

                Text {
                    text: "Slaytheland Customization Hub"
                    color: Theme.parchmentWhite
                    font.family: Theme.fontTitle
                    font.pixelSize: 26
                    font.bold: true
                }

                Item { Layout.fillWidth: true }

                Rectangle {
                    width: 32
                    height: 32
                    radius: Theme.radiusSmall
                    color: Theme.surfaceAlt
                    border.color: Theme.graphiteMuted

                    Text {
                        anchors.centerIn: parent
                        text: "✕"
                        color: Theme.parchment
                        font.pixelSize: 16
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: ShellState.toggleHub()
                    }
                }
            }

            // Tab Navigation Chips
            Row {
                id: tabRow
                spacing: 12

                readonly property var tabs: ["Princess Sanctuary", "Cabin & Scenery", "Living Shaders", "Voice & Audio"]

                Repeater {
                    model: tabRow.tabs

                    CharcoalButton {
                        required property var modelData
                        required property int index
                        text: modelData
                        active: root.currentTab === index
                        onClicked: root.currentTab = index
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: Theme.graphiteMuted
            }

            // Tab Pages Container
            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                // === TAB 0: Princess Sanctuary ===
                Item {
                    anchors.fill: parent
                    visible: root.currentTab === 0

                    RowLayout {
                        anchors.fill: parent
                        spacing: 20

                        // Vessel List (Scrollable)
                        ListView {
                            Layout.fillHeight: true
                            Layout.preferredWidth: 320
                            clip: true
                            model: VesselsData.vessels
                            spacing: 8

                            delegate: Rectangle {
                                id: vesselItem
                                required property var modelData
                                required property int index
                                property bool isSelected: RoomState.vesselIndex === index

                                width: 300
                                height: 50
                                radius: Theme.radiusSmall
                                color: isSelected ? Theme.bloodDried : (vesselDelegateMouse.containsMouse ? Theme.surfaceHover : Theme.surfaceAlt)
                                border.color: isSelected ? Theme.crimson : Theme.graphiteMuted
                                border.width: isSelected ? 2 : 1

                                Row {
                                    anchors.fill: parent
                                    anchors.leftMargin: 12
                                    anchors.rightMargin: 12
                                    spacing: 10

                                    Text {
                                        text: "👑"
                                        font.pixelSize: 16
                                        anchors.verticalCenter: parent.verticalCenter
                                    }

                                    Column {
                                        anchors.verticalCenter: parent.verticalCenter
                                        spacing: 2

                                        Text {
                                            text: vesselItem.modelData.name
                                            color: vesselItem.isSelected ? Theme.parchmentWhite : Theme.parchment
                                            font.family: Theme.fontTitle
                                            font.pixelSize: 16
                                            font.bold: true
                                        }

                                        Text {
                                            text: vesselItem.modelData.title
                                            color: Theme.pencilLight
                                            font.family: Theme.fontBody
                                            font.pixelSize: 14
                                        }
                                    }
                                }

                                MouseArea {
                                    id: vesselDelegateMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        Sfx.playBlade();
                                        RoomState.vesselIndex = vesselItem.index;
                                        VoiceBus.triggerQuote(vesselItem.modelData.name, vesselItem.modelData.quote);
                                    }
                                }
                            }
                        }

                        // Live Vessel Preview Card
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            radius: Theme.radiusMedium
                            color: Theme.surfaceAlt
                            border.color: Theme.graphiteMuted

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 20
                                spacing: 12

                                Image {
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    source: Theme.asset(RoomState.currentVessel.sprite)
                                    fillMode: Image.PreserveAspectFit
                                    asynchronous: true
                                }

                                Text {
                                    text: RoomState.currentVessel.name
                                    color: Theme.parchmentWhite
                                    font.family: Theme.fontTitle
                                    font.pixelSize: 22
                                    font.bold: true
                                }

                                Text {
                                    text: RoomState.currentVessel.description
                                    color: Theme.parchment
                                    font.family: Theme.fontBody
                                    font.pixelSize: 20
                                    wrapMode: Text.Wrap
                                    Layout.fillWidth: true
                                }

                                Text {
                                    text: "“" + RoomState.currentVessel.quote + "”"
                                    color: Theme.crimson
                                    font.family: Theme.fontBody
                                    font.pixelSize: 22
                                    font.italic: true
                                    wrapMode: Text.Wrap
                                    Layout.fillWidth: true
                                }
                            }
                        }
                    }
                }

                // === TAB 1: Cabin & Scenery ===
                Item {
                    anchors.fill: parent
                    visible: root.currentTab === 1

                    GridView {
                        anchors.fill: parent
                        cellWidth: 300
                        cellHeight: 180
                        clip: true
                        model: RoomsData.rooms

                        delegate: Rectangle {
                            id: roomCard
                            required property var modelData
                            required property int index
                            property bool isSelected: RoomState.roomIndex === index

                            width: 280
                            height: 160
                            radius: Theme.radiusMedium
                            color: isSelected ? Theme.bloodDried : Theme.surfaceAlt
                            border.color: isSelected ? Theme.crimson : Theme.graphiteMuted
                            border.width: isSelected ? 2 : 1

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 12
                                spacing: 8

                                Image {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 90
                                    source: Theme.asset(roomCard.modelData.layers[0].path)
                                    fillMode: Image.PreserveAspectCrop
                                    asynchronous: true
                                }

                                Text {
                                    text: roomCard.modelData.name
                                    color: roomCard.isSelected ? Theme.parchmentWhite : Theme.parchment
                                    font.family: Theme.fontTitle
                                    font.pixelSize: 16
                                    font.bold: true
                                }

                                Text {
                                    text: roomCard.modelData.description
                                    color: Theme.pencilLight
                                    font.family: Theme.fontBody
                                    font.pixelSize: 15
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    Sfx.playFootstep();
                                    RoomState.roomIndex = roomCard.index;
                                }
                            }
                        }
                    }
                }

                // === TAB 2: Living Shaders ===
                Item {
                    anchors.fill: parent
                    visible: root.currentTab === 2

                    Column {
                        id: shaderCol
                        anchors.centerIn: parent
                        width: 400
                        spacing: 24

                        RowLayout {
                            width: shaderCol.width

                            Text {
                                text: "Living-Pencil Line Boil Shader"
                                color: Theme.parchmentWhite
                                font.family: Theme.fontTitle
                                font.pixelSize: 18
                            }

                            Item { Layout.fillWidth: true }

                            CharcoalButton {
                                text: RoomState.shaderEnabled ? "Enabled" : "Disabled"
                                active: RoomState.shaderEnabled
                                onClicked: RoomState.shaderEnabled = !RoomState.shaderEnabled
                            }
                        }

                        SlaySlider {
                            width: shaderCol.width
                            label: "Line Boil Intensity"
                            value: RoomState.shaderIntensity
                            from: 0.0
                            to: 1.0
                            onValueModified: function(val) { RoomState.shaderIntensity = val; }
                        }

                        SlaySlider {
                            width: shaderCol.width
                            label: "Charcoal Edge Vignette"
                            value: RoomState.vignetteIntensity
                            from: 0.0
                            to: 1.0
                            onValueModified: function(val) { RoomState.vignetteIntensity = val; }
                        }
                    }
                }

                // === TAB 3: Voice & Audio ===
                Item {
                    anchors.fill: parent
                    visible: root.currentTab === 3

                    Column {
                        id: audioCol
                        anchors.centerIn: parent
                        width: 400
                        spacing: 20

                        RowLayout {
                            width: audioCol.width

                            Text {
                                text: "Authentic Voice Acting"
                                color: Theme.parchmentWhite
                                font.family: Theme.fontTitle
                                font.pixelSize: 18
                            }

                            Item { Layout.fillWidth: true }

                            CharcoalButton {
                                text: !VoiceBus.voiceMuted ? "Unmuted" : "Muted"
                                active: !VoiceBus.voiceMuted
                                onClicked: VoiceBus.voiceMuted = !VoiceBus.voiceMuted
                            }
                        }

                        SlaySlider {
                            width: audioCol.width
                            label: "Master Volume"
                            icon: "🗡️"
                            value: Audio.volume
                            from: 0.0
                            to: 1.0
                            onValueModified: function(val) { Audio.setVolume(val); }
                        }

                        SlaySlider {
                            width: audioCol.width
                            label: "Ambient Colin Stetson OST"
                            icon: "🎵"
                            value: Music.volume
                            from: 0.0
                            to: 1.0
                            onValueModified: function(val) { Music.volume = val; }
                        }

                        SlaySlider {
                            width: audioCol.width
                            label: "UI Foley Sound Effects"
                            icon: "🔔"
                            value: Sfx.volume
                            from: 0.0
                            to: 1.0
                            onValueModified: function(val) { Sfx.volume = val; }
                        }
                    }
                }
            }
        }
    }
}
