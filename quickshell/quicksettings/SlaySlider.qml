import QtQuick
import QtQuick.Layouts
import ".."
import "../widgets"

Item {
    id: root

    property string label: ""
    property string icon: ""
    property real value: 0.5
    property real from: 0.0
    property real to: 1.0
    property color activeColor: Theme.accent

    signal valueModified(real newValue)

    implicitWidth: 260
    implicitHeight: 48

    Column {
        anchors.fill: parent
        spacing: 6

        RowLayout {
            width: parent.width

            Row {
                spacing: 6
                GlyphIcon {
                    visible: root.icon !== ""
                    width: 16
                    height: 16
                    name: root.icon
                    color: Theme.parchment
                    anchors.verticalCenter: parent.verticalCenter
                }
                Text {
                    text: root.label
                    color: Theme.parchment
                    font.family: Theme.fontBody
                    font.pixelSize: 20
                    font.bold: true
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Item { Layout.fillWidth: true }

            Text {
                text: Math.round((root.value - root.from) / (root.to - root.from) * 100) + "%"
                color: Theme.pencilLight
                font.family: Theme.fontBody
                font.pixelSize: 18
            }
        }

        // Track & Blade Thumb
        Rectangle {
            id: track
            width: parent.width
            height: 12
            radius: 6
            color: Theme.surfaceAlt
            border.color: Theme.graphiteMuted

            // Filled portion
            Rectangle {
                width: Math.max(0, Math.min(parent.width, (root.value - root.from) / (root.to - root.from) * parent.width))
                height: parent.height
                radius: 6
                color: root.activeColor
            }

            // Blade thumb
            Rectangle {
                id: thumb
                width: 20
                height: 20
                radius: 10
                anchors.verticalCenter: parent.verticalCenter
                x: Math.max(0, Math.min(track.width - width, (root.value - root.from) / (root.to - root.from) * track.width - width / 2))
                color: sliderMouse.containsMouse ? Theme.parchmentWhite : Theme.parchment
                border.color: root.activeColor
                border.width: 2

                GlyphIcon {
                    anchors.centerIn: parent
                    width: 10
                    height: 10
                    name: "blade"
                    color: Theme.voidBlack
                }
            }

            MouseArea {
                id: sliderMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                preventStealing: true

                function updateValue(mouseX) {
                    var frac = Math.max(0.0, Math.min(1.0, mouseX / track.width));
                    var newVal = root.from + frac * (root.to - root.from);
                    root.value = newVal;
                    root.valueModified(newVal);
                }

                onPressed: function(mouse) { updateValue(mouse.x); }
                onPositionChanged: function(mouse) {
                    if (pressed) updateValue(mouse.x);
                }
            }
        }
    }
}
