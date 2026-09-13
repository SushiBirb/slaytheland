import QtQuick
import QtQuick.Layouts
import ".."
import "../services"
import "../widgets"

Item {
    id: root

    property string icon: "🗡️"
    property string title: "VOLUME"
    property real value: Audio.sink && Audio.sink.audio ? Audio.sink.audio.volume : 0
    property bool muted: Audio.sink && Audio.sink.audio ? Audio.sink.audio.muted : false
    property bool active: false

    width: 240
    height: 90
    anchors.centerIn: parent

    opacity: root.active ? 1.0 : 0.0
    scale: root.active ? 1.0 : 0.85
    Behavior on opacity { NumberAnimation { duration: 180; easing.type: Easing.OutQuad } }
    Behavior on scale { NumberAnimation { duration: 180; easing.type: Easing.OutBack } }

    Timer {
        id: hideTimer
        interval: 1600
        onTriggered: root.active = false
    }

    Connections {
        target: Audio.sink && Audio.sink.audio ? Audio.sink.audio : null
        function onVolumeChanged() {
            root.icon = "🗡️";
            root.title = root.muted ? "MUTED" : "PRISTINE BLADE";
            root.active = true;
            hideTimer.restart();
        }
        function onMutedChanged() {
            root.icon = root.muted ? "🩸" : "🗡️";
            root.title = root.muted ? "MUTED" : "PRISTINE BLADE";
            root.active = true;
            hideTimer.restart();
        }
    }

    Border {
        anchors.fill: parent
        borderMargin: 16
    }

    Rectangle {
        anchors.fill: parent
        anchors.margins: 4
        color: Qt.rgba(0.06, 0.05, 0.08, 0.95)
        radius: Theme.radiusSmall
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 14
        spacing: 8

        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            Text {
                text: root.icon
                font.pixelSize: 18
            }

            Text {
                text: root.title
                color: Theme.parchmentWhite
                font.family: Theme.fontTitle
                font.pixelSize: 14
                font.bold: true
                Layout.fillWidth: true
            }

            Text {
                text: root.muted ? "0%" : Math.round(root.value * 100) + "%"
                color: Theme.parchment
                font.family: Theme.fontTitle
                font.pixelSize: 15
                font.bold: true
            }
        }

        // Sketch Level Bar
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 8
            radius: 4
            color: Theme.surfaceAlt
            border.color: Theme.graphiteMuted

            Rectangle {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: parent.width * Math.max(0, Math.min(1, root.muted ? 0 : root.value))
                radius: 4
                color: root.muted ? Theme.graphiteMuted : Theme.crimson

                Behavior on width { NumberAnimation { duration: 100 } }
            }
        }
    }
}
