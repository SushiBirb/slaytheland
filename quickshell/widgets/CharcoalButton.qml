import QtQuick
import ".."

Rectangle {
    id: root

    property string text: ""
    property string iconSource: ""
    property color textColor: hovered ? Theme.parchmentWhite : Theme.parchment
    property color activeColor: Theme.crimson
    property bool active: false
    property bool isChoice: false
    property int fontSize: 20
    property string fontFamily: isChoice ? Theme.fontTitle : Theme.fontBody

    signal clicked()

    implicitWidth: Math.max(120, label.implicitWidth + 32)
    implicitHeight: 40

    color: active ? Theme.bloodDried : (hovered ? Theme.surfaceHover : Theme.surfaceAlt)
    radius: Theme.radiusSmall
    border.color: active ? Theme.crimson : (hovered ? Theme.crimson : Theme.graphiteMuted)
    border.width: hovered || active ? 2 : 1

    readonly property bool hovered: mouseArea.containsMouse
    readonly property bool pressed: mouseArea.pressed

    scale: pressed ? 0.97 : (hovered ? 1.02 : 1.0)
    Behavior on scale { NumberAnimation { duration: 100 } }
    Behavior on color { ColorAnimation { duration: 150 } }
    Behavior on border.color { ColorAnimation { duration: 150 } }

    Row {
        anchors.centerIn: parent
        spacing: 8

        Text {
            visible: root.isChoice && root.hovered
            text: "🗡️"
            font.pixelSize: root.fontSize - 4
            anchors.verticalCenter: parent.verticalCenter
        }

        Image {
            visible: root.iconSource !== ""
            source: root.iconSource
            width: root.fontSize
            height: root.fontSize
            fillMode: Image.PreserveAspectFit
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            id: label
            text: root.text
            color: root.textColor
            font.family: root.fontFamily
            font.pixelSize: root.fontSize
            font.bold: root.hovered || root.active
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            Sfx.playButton();
            root.clicked();
        }
    }
}
