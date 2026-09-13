import QtQuick
import ".."

Item {
    id: root

    property real gazeX: RoomState.cursorX
    property real gazeY: RoomState.cursorY
    readonly property bool isPrincessSpeaking: VoiceBus.isTalking && (
        VoiceBus.currentSpeaker.indexOf("Princess") !== -1 ||
        VoiceBus.currentSpeaker.indexOf("Witch") !== -1 ||
        VoiceBus.currentSpeaker.indexOf("Damsel") !== -1 ||
        VoiceBus.currentSpeaker.indexOf("Nightmare") !== -1 ||
        VoiceBus.currentSpeaker.indexOf("Tower") !== -1 ||
        VoiceBus.currentSpeaker.indexOf("Razor") !== -1 ||
        VoiceBus.currentSpeaker.indexOf("Adversary") !== -1 ||
        VoiceBus.currentSpeaker.indexOf("Spectre") !== -1 ||
        VoiceBus.currentSpeaker.indexOf("Prisoner") !== -1 ||
        VoiceBus.currentSpeaker.indexOf("Beast") !== -1 ||
        VoiceBus.currentSpeaker.indexOf("Stranger") !== -1 ||
        VoiceBus.currentSpeaker === RoomState.currentVesselName
    )
    property bool talking: isPrincessSpeaking
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
        transformOrigin: Item.Center

        // Parallax locked to wall/shackles depth (depth: 0.08 -> 25.6px factor)
        readonly property real depthFactor: 25.6
        property real offsetX: depthFactor * RoomState.cursorX * -1.0
        property real offsetY: (depthFactor * 0.5) * RoomState.cursorY * -1.0

        x: offsetX
        y: offsetY
        rotation: 0
        scale: root.breathScale

        Behavior on x { SpringAnimation { spring: 4.5; damping: 0.35; mass: 1.0; epsilon: 0.05 } }
        Behavior on y { SpringAnimation { spring: 4.5; damping: 0.35; mass: 1.0; epsilon: 0.05 } }

        // Idle sprite layer - exact 2100x1200 canvas crop matching room layers
        Image {
            id: idleImg
            anchors.fill: parent
            anchors.margins: -120
            fillMode: Image.PreserveAspectCrop
            source: Theme.asset(RoomState.currentSprite)
            asynchronous: true
            opacity: (root.talking && root.talkFrame) ? 0.0 : (root.blinking ? 0.88 : 1.0)
            visible: opacity > 0.0
            onStatusChanged: {
                if (status === Image.Error) {
                    console.log("Princess idle sprite error loading:", source);
                }
            }
        }

        // Talking sprite layer - crossfaded without rapid texture reloading
        Image {
            id: talkImg
            anchors.fill: parent
            anchors.margins: -120
            fillMode: Image.PreserveAspectCrop
            source: Theme.asset(RoomState.currentTalkSprite)
            asynchronous: true
            opacity: (root.talking && root.talkFrame) ? 1.0 : 0.0
            visible: opacity > 0.0
            onStatusChanged: {
                if (status === Image.Error) {
                    console.log("Princess talk sprite error loading:", source);
                }
            }
        }

        // Hit-box strictly constrained to princess character figure
        MouseArea {
            width: Math.min(parent.width * 0.35, 320)
            height: Math.min(parent.height * 0.45, 380)
            anchors.centerIn: parent
            anchors.verticalCenterOffset: (RoomState.currentVessel && RoomState.currentVessel.chapter === 1) ? -parent.height * 0.11 : parent.height * 0.05
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                Sfx.playBlade();
                RoomState.nextPrincessQuote();
            }
        }
    }
}
