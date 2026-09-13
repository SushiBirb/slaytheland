import QtQuick
import QtQuick.Layouts
import ".."
import "../services"
import "../widgets"

Item {
    id: root

    required property var screen

    readonly property var stateSlice: ShellState.forScreen(screen)
    readonly property bool isOpen: stateSlice ? stateSlice.quicksettingsOpen : false

    anchors.fill: parent

    visible: panel.x < root.width

    // Dimmed background overlay
    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0.4)
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
        width: 340
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.topMargin: 12
        anchors.bottomMargin: 12

        x: root.isOpen ? (root.width - width - 12) : (root.width + 10)
        Behavior on x { NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }

        Border {
            anchors.fill: parent
            borderMargin: 24
        }

        Rectangle {
            anchors.fill: parent
            anchors.margins: 6
            color: Qt.rgba(0.08, 0.07, 0.09, 0.95)
            radius: Theme.radiusSmall
        }

        Column {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 16

            // Header: Clock & Battery & Close
            RowLayout {
                width: parent.width

                Column {
                    Layout.fillWidth: true
                    spacing: 2

                    Text {
                        text: Qt.formatDateTime(new Date(), "hh:mm")
                        color: Theme.parchmentWhite
                        font.family: Theme.fontTitle
                        font.pixelSize: 28
                        font.bold: true
                    }

                    Text {
                        text: Qt.formatDateTime(new Date(), "dddd, MMMM d")
                        color: Theme.pencilLight
                        font.family: Theme.fontBody
                        font.pixelSize: 18
                    }
                }

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
                        onClicked: ShellState.toggleQuicksettings()
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: Theme.graphiteMuted
            }

            // Quick Hardware Toggles Grid
            QuickSettingsTiles {
                width: parent.width
            }

            Rectangle {
                width: parent.width
                height: 1
                color: Theme.graphiteMuted
            }

            // Volume Sliders
            SlaySlider {
                width: parent.width
                label: "Master Sound"
                icon: "🗡️"
                value: Audio.volume
                from: 0.0
                to: 1.0
                onValueModified: function(val) {
                    Audio.setVolume(val);
                }
            }

            SlaySlider {
                width: parent.width
                label: "Microphone"
                icon: "🎙️"
                value: Audio.inputVolume
                from: 0.0
                to: 1.0
                onValueModified: function(val) {
                    Audio.setInputVolume(val);
                }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: Theme.graphiteMuted
            }

            // Media Hero (Soundtrack & OST)
            Rectangle {
                width: parent.width
                height: 64
                radius: Theme.radiusSmall
                color: Theme.surfaceAlt
                border.color: Theme.bloodDried

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 8

                    Text {
                        text: "🎵"
                        font.pixelSize: 20
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
                        }
                    }

                    Rectangle {
                        width: 32
                        height: 32
                        radius: Theme.radiusSmall
                        color: Theme.bloodDried
                        border.color: Theme.crimson

                        Text {
                            anchors.centerIn: parent
                            text: Music.isPlaying ? "⏸" : "▶"
                            color: Theme.parchmentWhite
                            font.pixelSize: 14
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                Sfx.playButton();
                                Music.togglePlay();
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

            // Narrative Power Choices
            PowerChoices {
                width: parent.width
            }
        }
    }
}
