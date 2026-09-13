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
            model: RoomState.currentLayers

            Item {
                id: layerItem
                required property var modelData
                required property int index

                width: parent.width
                height: parent.height

                // Depth offset calculated from mouse gaze (moves opposite to cursor)
                // Layer 0 is deep background (subtle shift), subsequent layers shift progressively more for 2.5D depth
                readonly property real depthFactor: modelData.depth ? (modelData.depth * 320.0) : ((index + 1) * 22.0)
                property real offsetX: depthFactor * RoomState.cursorX * -1.0
                property real offsetY: (depthFactor * 0.5) * RoomState.cursorY * -1.0

                x: offsetX
                y: offsetY
                Behavior on x { SpringAnimation { spring: 4.5; damping: 0.35; mass: 1.0; epsilon: 0.05 } }
                Behavior on y { SpringAnimation { spring: 4.5; damping: 0.35; mass: 1.0; epsilon: 0.05 } }

                Image {
                    anchors.fill: parent
                    anchors.margins: -120 // Bleed for smooth parallax motion without edges
                    source: Theme.asset(layerItem.modelData.path)
                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true
                }
            }
        }
    }

    // Princess Companion (Bottom-Centered, displayed only in narrative scenes like the Basement)
    Princess {
        id: companion
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        width: Math.min(parent.width, 1000)
        height: parent.height

        visible: opacity > 0.0
        opacity: (root.companionVisible && RoomState.currentRoom && RoomState.currentRoom.hasPrincess) ? 1.0 : 0.0

        Behavior on opacity { NumberAnimation { duration: 350; easing.type: Easing.InOutQuad } }
    }
}
