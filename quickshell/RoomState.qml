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
    property int vesselQuoteIndex: 0

    readonly property var currentRoom: RoomsData.rooms[roomIndex]
    readonly property var currentVessel: VesselsData.vessels[vesselIndex]

    // Dynamic room layers: returns tailored basement for current vessel when in the basement
    readonly property var currentLayers: {
        if (currentRoom && (currentRoom.id === "basement" || currentRoom.id === "distant_basement")) {
            if (currentVessel && currentVessel.basementLayers && currentVessel.basementLayers.length > 0) {
                return currentVessel.basementLayers;
            }
        }
        return currentRoom && currentRoom.layers ? currentRoom.layers : [];
    }

    // Explicit reactive properties for QML bindings
    readonly property string currentSprite: currentVessel && currentVessel.sprite ? currentVessel.sprite : ""
    readonly property string currentTalkSprite: currentVessel && currentVessel.talkSprite ? currentVessel.talkSprite : currentSprite
    readonly property string currentVesselName: currentVessel && currentVessel.name ? currentVessel.name : "The Princess"
    readonly property string currentVesselQuote: currentVessel && currentVessel.quote ? currentVessel.quote : ""
    readonly property string currentVesselAudio: currentVessel && currentVessel.audioFile ? currentVessel.audioFile : "audio/voices/princess_chains.flac"

    // Dynamic mood color reflecting current vessel
    readonly property color moodColor: currentVessel && currentVessel.accentColor ? currentVessel.accentColor : "#c72c41"
    readonly property color moodMuted: Qt.darker(moodColor, 1.3)

    // Active cursor singleton reference ensures Cursor process is running
    readonly property real _cursorGx: Cursor.gx
    readonly property real _cursorGy: Cursor.gy

    // Cursor tracking coordinates for parallax (normalized -1.0 to 1.0)
    property real cursorX: 0.0
    property real cursorY: 0.0

    property real parallaxStrength: 1.0

    // Shader knobs: controls Hyprland window border pencil shader
    property bool shaderEnabled: true
    property real shaderIntensity: 0.5
    property real vignetteIntensity: 0.0

    Timer {
        id: shaderDebounce
        interval: 60
        repeat: false
        onTriggered: root.applyScreenShader()
    }

    function applyScreenShader() {
        var val = root.shaderEnabled ? root.shaderIntensity.toFixed(2) : "0.0";
        var cmd = "for p in \"$HOME/slaytheland/scripts/set-shader-intensity.sh\" \"$HOME/Projects/slaytheland/scripts/set-shader-intensity.sh\" \"/home/arch/slaytheland/scripts/set-shader-intensity.sh\"; do if [ -f \"$p\" ]; then exec \"$p\" " + val + "; fi; done";
        Quickshell.execDetached(["bash", "-c", cmd]);
    }

    onShaderEnabledChanged: {
        shaderDebounce.restart();
    }

    onShaderIntensityChanged: {
        shaderDebounce.restart();
    }

    Component.onCompleted: {
        applyScreenShader();
    }

    function updateGlobalCursor(cx, cy) {
        var scr = (Quickshell.screens && Quickshell.screens.length > 0) ? Quickshell.screens[0] : null;
        var sw = scr ? scr.width : 1280.0;
        var sh = scr ? scr.height : 800.0;
        root.cursorX = Math.max(-1.0, Math.min(1.0, ((cx / sw) - 0.5) * 2.0));
        root.cursorY = Math.max(-1.0, Math.min(1.0, ((cy / sh) - 0.5) * 2.0));
    }

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
        console.log("Room cycled to:", root.currentRoom.name);
    }

    function prevRoom() {
        root.roomIndex = (root.roomIndex - 1 + RoomsData.rooms.length) % RoomsData.rooms.length;
    }

    function setVessel(id) {
        for (var i = 0; i < VesselsData.vessels.length; i++) {
            if (VesselsData.vessels[i].id === id) {
                root.vesselIndex = i;
                root.vesselQuoteIndex = 0;
                return;
            }
        }
    }

    function nextVessel() {
        root.vesselIndex = (root.vesselIndex + 1) % VesselsData.vessels.length;
        root.vesselQuoteIndex = 0;
        console.log("Vessel cycled to:", root.currentVessel.name, "sprite:", root.currentVessel.sprite);
    }

    function prevVessel() {
        root.vesselIndex = (root.vesselIndex - 1 + VesselsData.vessels.length) % VesselsData.vessels.length;
        root.vesselQuoteIndex = 0;
    }

    function nextPrincessQuote() {
        if (!currentVessel) return;
        var qList = currentVessel.quotes;
        if (qList && qList.length > 0) {
            root.vesselQuoteIndex = (root.vesselQuoteIndex + 1) % qList.length;
            var q = qList[root.vesselQuoteIndex];
            VoiceBus.triggerQuote(currentVesselName, q.text, q.audio);
        } else if (currentVesselQuote && currentVesselQuote !== "") {
            VoiceBus.triggerQuote(currentVesselName, currentVesselQuote, currentVesselAudio);
        }
    }

    function updateCursor(mouseX, mouseY, screenW, screenH) {
        if (screenW > 0 && screenH > 0) {
            root.cursorX = ((mouseX / screenW) - 0.5) * 2.0;
            root.cursorY = ((mouseY / screenH) - 0.5) * 2.0;
        }
    }
}
