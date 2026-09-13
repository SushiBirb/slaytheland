import QtQuick
import QtQuick.Layouts
import ".."
import "../services"
import "../widgets"

Item {
    id: root

    required property var screen

    anchors.top: parent.top
    anchors.right: parent.right
    anchors.topMargin: 56
    anchors.rightMargin: 16
    width: 360
    height: notifColumn.implicitHeight

    Column {
        id: notifColumn
        width: parent.width
        spacing: 8

        Repeater {
            model: Notifs.popups

            Item {
                id: card
                required property var modelData
                width: notifColumn.width
                height: 90

                Border {
                    anchors.fill: parent
                    borderMargin: 16
                }

                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 4
                    color: Qt.rgba(0.08, 0.07, 0.09, 0.95)
                    radius: Theme.radiusSmall
                }

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 4

                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            text: card.modelData.appName || "Notification"
                            color: Theme.crimson
                            font.family: Theme.fontTitle
                            font.pixelSize: 14
                            font.bold: true
                        }

                        Item { Layout.fillWidth: true }

                        Rectangle {
                            Layout.preferredWidth: 20
                            Layout.preferredHeight: 20
                            radius: Theme.radiusSmall
                            color: "transparent"

                            Text {
                                anchors.centerIn: parent
                                text: "✕"
                                color: Theme.pencilLight
                                font.pixelSize: 12
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: Notifs.dismiss(card.modelData)
                            }
                        }
                    }

                    Text {
                        text: card.modelData.summary || ""
                        color: Theme.parchmentWhite
                        font.family: Theme.fontTitle
                        font.pixelSize: 15
                        font.bold: true
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }

                    Text {
                        text: card.modelData.body || ""
                        color: Theme.parchment
                        font.family: Theme.fontBody
                        font.pixelSize: 16
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }
                }
            }
        }
    }
}
