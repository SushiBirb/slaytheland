pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Hyprland
import "data/rooms.js" as RoomsData
import "data/vessels.js" as VesselsData

Singleton {
    id: root

    property int roomIndex: 0
    property int vesselIndex: 0

    readonly property var currentRoom: RoomsData.rooms[roomIndex]
    readonly property var currentVessel: VesselsData.vessels[vesselIndex]

    // Cursor tracking coordinates for parallax (normalized -1.0 to 1.0)
    property real cursorX: 0.0
    property real cursorY: 0.0

    // Window focus freeze: When windows are focused, freeze parallax over 400ms
    readonly property bool windowFocused: Hyprland.activeWindow !== null && Hyprland.activeWindow.address !== ""
    property real parallaxStrength: windowFocused ? 0.2 : 1.0
    Behavior on parallaxStrength { NumberAnimation { duration: 400; easing.type: Easing.OutQuad } }

    // Shader knobs
    property bool shaderEnabled: true
    property real shaderIntensity: 0.6
    property real vignetteIntensity: 0.5

    function setRoom(id) {
        for (var i = 0; i < RoomsData.rooms.length; i++) {
            if (RoomsData.rooms[i].id === id) {
                root.roomIndex = i;
                return;
            }
        }
    }

    function nextRoom() {
        root.roomIndex = (root.roomIndex + 1) % RoomsData.rooms.length;
    }

    function prevRoom() {
        root.roomIndex = (root.roomIndex - 1 + RoomsData.rooms.length) % RoomsData.rooms.length;
    }

    function setVessel(id) {
        for (var i = 0; i < VesselsData.vessels.length; i++) {
            if (VesselsData.vessels[i].id === id) {
                root.vesselIndex = i;
                return;
            }
        }
    }

    function nextVessel() {
        root.vesselIndex = (root.vesselIndex + 1) % VesselsData.vessels.length;
    }

    function prevVessel() {
        root.vesselIndex = (root.vesselIndex - 1 + VesselsData.vessels.length) % VesselsData.vessels.length;
    }

    function updateCursor(mouseX, mouseY, screenW, screenH) {
        if (screenW > 0 && screenH > 0) {
            root.cursorX = ((mouseX / screenW) - 0.5) * 2.0;
            root.cursorY = ((mouseY / screenH) - 0.5) * 2.0;
        }
    }
}
