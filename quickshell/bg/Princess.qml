import QtQuick
import ".."

Item {
    id: root

    property real gazeX: RoomState.cursorX
    property real gazeY: RoomState.cursorY
    property bool talking: VoiceBus.isTalking
    property bool blinking: false
    property int poseIndex: 0

    implicitWidth: 600
    implicitHeight: 750

    // Procedural breathing sine-wave
    property real time: 0.0
    Timer {
        interval: 16
        running: true
        repeat: true
        onTriggered: root.time += 0.04
    }

    readonly property real breathScale: 1.0 + 0.015 * Math.sin(root.time)

    // Random eye blink timer (every 3 to 7 seconds)
    Timer {
        id: blinkTimer
        interval: 3000 + Math.random() * 4000
        running: true
        repeat: true
        onTriggered: {
            root.blinking = true;
            blinkDuration.restart();
            interval = 3000 + Math.random() * 4000;
        }
    }

    Timer {
        id: blinkDuration
        interval: 120
        onTriggered: root.blinking = false
    }

    // Lip-sync alternator during dialogue (8 Hz)
    property bool talkFrame: false
    Timer {
        interval: 125 // 8 Hz
        running: root.talking
        repeat: true
        onTriggered: root.talkFrame = !root.talkFrame
    }

    Item {
        id: container
        anchors.fill: parent
        transformOrigin: Item.Bottom

        // Gaze lean & procedural breathing
        rotation: root.gazeX * 3.5
        scale: root.breathScale

        Behavior on rotation { NumberAnimation { duration: 180; easing.type: Easing.OutQuad } }

        Image {
            id: spriteImg
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
            source: (root.talking && root.talkFrame)
                    ? Theme.asset(RoomState.currentVessel.talkSprite)
                    : Theme.asset(RoomState.currentVessel.sprite)
            asynchronous: true
            opacity: root.blinking ? 0.88 : 1.0
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                Sfx.playBlade();
                VoiceBus.triggerQuote(RoomState.currentVessel.name, RoomState.currentVessel.quote);
            }
        }
    }
}
