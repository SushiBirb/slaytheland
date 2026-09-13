import QtQuick
import Quickshell
import ".."
import "../services"

Item {
    id: root

    required property var screen

    anchors.fill: parent

    readonly property var stateSlice: ShellState.forScreen(screen)
    readonly property bool companionVisible: stateSlice ? stateSlice.companionVisible : true

    // Parallax tracking
    MouseArea {
        id: tracker
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.NoButton
        onPositionChanged: function(mouse) {
            RoomState.updateCursor(mouse.x, mouse.y, root.width, root.height);
        }
    }

    // Base dark void backing
    Rectangle {
        anchors.fill: parent
        color: Theme.voidBlack
    }

    // Parallax layers container
    Item {
        id: sceneContainer
        anchors.fill: parent

        Repeater {
            model: RoomState.currentRoom.layers

            Item {
                id: layerItem
                required property var modelData
                required property int index

                anchors.fill: parent

                // Depth offset calculated from mouse gaze
                property real offsetX: (modelData.depth || 0.05) * RoomState.cursorX * RoomState.parallaxStrength * 50
                property real offsetY: (modelData.depth || 0.05) * RoomState.cursorY * RoomState.parallaxStrength * 30

                x: offsetX
                y: offsetY
                Behavior on x { NumberAnimation { duration: 150; easing.type: Easing.OutQuad } }
                Behavior on y { NumberAnimation { duration: 150; easing.type: Easing.OutQuad } }

                Image {
                    anchors.fill: parent
                    anchors.margins: -40 // Extra bleed for parallax motion
                    source: Theme.asset(layerItem.modelData.path)
                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true
                }
            }
        }
    }

    // Princess Companion (Bottom-Centered)
    Princess {
        id: companion
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 30

        visible: opacity > 0.0
        opacity: root.companionVisible ? 1.0 : 0.0
        y: root.companionVisible ? 0 : 60

        Behavior on opacity { NumberAnimation { duration: 350; easing.type: Easing.InOutQuad } }
        Behavior on y { NumberAnimation { duration: 350; easing.type: Easing.OutBack } }
    }

    // Living-Pencil Boil GLSL Shader
    ShaderEffect {
        id: boilShader
        anchors.fill: parent
        visible: RoomState.shaderEnabled

        property variant source: ShaderEffectSource {
            sourceItem: sceneContainer
            live: true
            hideSource: false
        }

        property real time: 0.0
        property real intensity: RoomState.shaderIntensity
        property real vignette: RoomState.vignetteIntensity
        property vector2d resolution: Qt.vector2d(root.width, root.height)

        fragmentShader: Qt.resolvedUrl("../shaders/pencil_boil.frag.qsb")

        Timer {
            interval: 16
            running: boilShader.visible
            repeat: true
            onTriggered: boilShader.time += 0.016
        }
    }
}
