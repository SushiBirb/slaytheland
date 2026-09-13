import QtQuick
import QtQuick.Layouts
import ".."
import "../services"
import "../widgets"
import "../quicksettings"
import "../data/vessels.js" as VesselsData
import "../data/rooms.js" as RoomsData

Item {
    id: root

    required property var screen

    readonly property var stateSlice: ShellState.forScreen(screen)
    readonly property bool isOpen: stateSlice ? stateSlice.hubOpen : false

    anchors.fill: parent
    visible: opacity > 0.0
    opacity: root.isOpen ? 1.0 : 0.0
    Behavior on opacity { NumberAnimation { duration: 250 } }

    property string currentSection: "sanctuary"
    property string searchQuery: ""

    // Fullscreen backdrop overlay
    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(0.04, 0.03, 0.05, 0.92)

        MouseArea {
            anchors.fill: parent
            onClicked: ShellState.toggleHub()
        }
    }

    // Modal Hub Window (Adapted from Ryoku Hub layout)
    Item {
        id: hubContainer
        width: Math.min(1180, parent.width - 40)
        height: Math.min(760, parent.height - 40)
        anchors.centerIn: parent

        Border {
            anchors.fill: parent
            borderMargin: 24
        }

        Rectangle {
            anchors.fill: parent
            anchors.margins: 6
            color: Theme.charcoal
            radius: Theme.radiusMedium
        }

        RowLayout {
            anchors.fill: parent
            anchors.margins: 18
            spacing: 16

            // =================================================================
            // LEFT RAIL: Navigation & Search (Ryoku Hub Pattern)
            // =================================================================
            Item {
                Layout.preferredWidth: 260
                Layout.fillHeight: true

                Rectangle {
                    anchors.fill: parent
                    color: Theme.voidBlack
                    radius: Theme.radiusSmall
                    border.color: Theme.graphiteMuted
                }

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 10

                    // Hub Branding
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 8
                        GlyphIcon {
                            width: 20
                            height: 20
                            name: "blade"
                            color: Theme.crimsonVivid
                        }
                        Column {
                            Layout.fillWidth: true
                            Text {
                                text: "Ryoku Settings"
                                color: Theme.parchmentWhite
                                font.family: Theme.fontTitle
                                font.pixelSize: 18
                                font.bold: true
                            }
                            Text {
                                text: "slaytheland edition"
                                color: Theme.accent
                                font.family: Theme.fontBody
                                font.pixelSize: 13
                            }
                        }
                    }

                    // Search Field (Ryoku rail search)
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 34
                        radius: Theme.radiusSmall
                        color: Theme.surfaceAlt
                        border.color: searchBox.activeFocus ? Theme.accent : Theme.graphiteMuted

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 8
                            anchors.rightMargin: 8
                            spacing: 6

                            Text { text: "🔍"; font.pixelSize: 12 }
                            TextInput {
                                id: searchBox
                                Layout.fillWidth: true
                                color: Theme.parchmentWhite
                                font.family: Theme.fontBody
                                font.pixelSize: 18
                                clip: true
                                onTextChanged: root.searchQuery = text.toLowerCase().trim()

                                Text {
                                    visible: !searchBox.text
                                    text: "Search settings..."
                                    color: Theme.pencilLight
                                    font.family: Theme.fontBody
                                    font.pixelSize: 18
                                }
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: Theme.graphiteMuted
                    }

                    // Rail Categories List
                    ListView {
                        id: railList
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        clip: true
                        spacing: 4
                        model: [
                            { key: "sanctuary", name: "Princess Sanctuary", icon: "👑" },
                            { key: "scenery",   name: "Cabin & Scenery",    icon: "🌲" },
                            { key: "shaders",   name: "Living Pencil",      icon: "✏️" },
                            { key: "audio",     name: "Sound & Voices",     icon: "🔊" },
                            { key: "displays",  name: "Displays & Scale",   icon: "🖥️" },
                            { key: "keybinds",  name: "Keybinds Grimoire",  icon: "⌨️" },
                            { key: "windows",   name: "Window Rules",       icon: "🪟" },
                            { key: "lock",      name: "Hyprlock Screen",    icon: "🔒" },
                            { key: "about",     name: "About & Loop State", icon: "ℹ️" }
                        ]

                        delegate: Rectangle {
                            id: railItem
                            required property var modelData
                            width: railList.width
                            height: 38
                            radius: Theme.radiusSmall
                            readonly property bool isSelected: root.currentSection === modelData.key
                            color: isSelected ? Theme.surfaceSelected : (itemMouse.containsMouse ? Theme.surfaceHover : "transparent")
                            border.color: isSelected ? Theme.accent : "transparent"
                            border.width: 1

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 10
                                anchors.rightMargin: 10
                                spacing: 10

                                Text {
                                    text: railItem.modelData.icon
                                    font.pixelSize: 16
                                }

                                Text {
                                    Layout.fillWidth: true
                                    text: railItem.modelData.name
                                    color: railItem.isSelected ? Theme.parchmentWhite : (itemMouse.containsMouse ? Theme.parchment : Theme.pencilLight)
                                    font.family: Theme.fontTitle
                                    font.pixelSize: 14
                                    font.bold: railItem.isSelected
                                    elide: Text.ElideRight
                                }
                            }

                            MouseArea {
                                id: itemMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    Sfx.playButton();
                                    root.currentSection = railItem.modelData.key;
                                }
                            }
                        }
                    }

                    // Rail Footer: Quick Close
                    CharcoalButton {
                        Layout.fillWidth: true
                        text: "Dismiss (Esc)"
                        fontSize: 14
                        onClicked: ShellState.toggleHub()
                    }
                }
            }

            // =================================================================
            // CENTER: Content Area (Schema Page View)
            // =================================================================
            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 12

                    // Page Header
                    RowLayout {
                        Layout.fillWidth: true

                        Column {
                            Layout.fillWidth: true
                            spacing: 2

                            Text {
                                text: {
                                    switch (root.currentSection) {
                                        case "sanctuary": return "Princess Sanctuary";
                                        case "scenery":   return "Cabin & Scenery Studio";
                                        case "shaders":   return "Living Pencil & Shaders";
                                        case "audio":     return "Audio & Voice Bus Studio";
                                        case "displays":  return "Displays & Hardware Monitors";
                                        case "keybinds":  return "Keybinds Grimoire Catalogue";
                                        case "windows":   return "Hyprland Windows & Animations";
                                        case "lock":      return "Hyprlock Direct-to-Desktop Lock";
                                        case "about":     return "Loop Duration & System Health";
                                        default:          return "Settings";
                                    }
                                }
                                color: Theme.parchmentWhite
                                font.family: Theme.fontTitle
                                font.pixelSize: 24
                                font.bold: true
                            }

                            Text {
                                text: {
                                    switch (root.currentSection) {
                                        case "sanctuary": return "Browse, manifest, and preview the 20 vessels of the Princess.";
                                        case "scenery":   return "Switch room perspectives, skybox plates, and wallpaper crossfades.";
                                        case "shaders":   return "Tune the visual novel 12 FPS line boil, Worley noise, and edge vignette.";
                                        case "audio":     return "Mix PipeWire volume, microphone gain, Narrator speech, and OST playback.";
                                        case "displays":  return "Configure Hyprland resolution, display scale, and refresh rates.";
                                        case "keybinds":  return "Muscle-memory keyboard shortcut catalogue and window navigation.";
                                        case "windows":   return "Dual-tone border gradients, tension beziers, and window gaps.";
                                        case "lock":      return "Configure the authentic Mirror Room lockscreen and avatar presentation.";
                                        case "about":     return "Slay the Princess ownership verification, system uptime, and doctor report.";
                                        default:          return "";
                                    }
                                }
                                color: Theme.pencilLight
                                font.family: Theme.fontBody
                                font.pixelSize: 16
                            }
                        }

                        // Close Button
                        Rectangle {
                            width: 32
                            height: 32
                            radius: Theme.radiusSmall
                            color: Theme.surfaceAlt
                            border.color: Theme.graphiteMuted

                            Text {
                                anchors.centerIn: parent
                                text: "✕"
                                color: Theme.parchment
                                font.pixelSize: 15
                            }
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: ShellState.toggleHub()
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: Theme.graphiteMuted
                    }

                    // Scrollable Page Content
                    Flickable {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        contentWidth: width
                        contentHeight: activePageLoader.implicitHeight
                        clip: true
                        boundsBehavior: Flickable.StopAtBounds

                        Column {
                            id: activePageLoader
                            width: parent.width
                            spacing: 14

                            // -------------------------------------------------
                            // 1. PRINCESS SANCTUARY
                            // -------------------------------------------------
                            Column {
                                visible: root.currentSection === "sanctuary"
                                width: parent.width
                                spacing: 12

                                Grid {
                                    width: parent.width
                                    columns: 2
                                    columnSpacing: 10
                                    rowSpacing: 10

                                    Repeater {
                                        model: VesselsData.vessels

                                        Rectangle {
                                            id: vesselCard
                                            required property var modelData
                                            required property int index
                                            width: (parent.width - 10) / 2
                                            height: 80
                                            radius: Theme.radiusSmall
                                            readonly property bool isCurrent: RoomState.vesselIndex === index
                                            color: isCurrent ? Theme.surfaceSelected : (cardMouse.containsMouse ? Theme.surfaceHover : Theme.surfaceAlt)
                                            border.color: isCurrent ? Theme.accent : Theme.graphiteMuted
                                            border.width: isCurrent ? 2 : 1

                                            RowLayout {
                                                anchors.fill: parent
                                                anchors.margins: 10
                                                spacing: 10

                                                Rectangle {
                                                    width: 44
                                                    height: 44
                                                    radius: 22
                                                    color: Theme.voidBlack
                                                    border.color: vesselCard.modelData.accentColor || Theme.accent
                                                    border.width: 2

                                                    Image {
                                                        anchors.fill: parent
                                                        anchors.margins: 2
                                                        source: Theme.asset(vesselCard.modelData.sprite)
                                                        fillMode: Image.PreserveAspectCrop
                                                    }
                                                }

                                                Column {
                                                    Layout.fillWidth: true
                                                    spacing: 1
                                                    Text {
                                                        text: vesselCard.modelData.name
                                                        color: Theme.parchmentWhite
                                                        font.family: Theme.fontTitle
                                                        font.pixelSize: 15
                                                        font.bold: true
                                                    }
                                                    Text {
                                                        text: vesselCard.modelData.title
                                                        color: Theme.accent
                                                        font.family: Theme.fontBody
                                                        font.pixelSize: 14
                                                    }
                                                    Text {
                                                        text: vesselCard.modelData.quote
                                                        color: Theme.pencilLight
                                                        font.family: Theme.fontBody
                                                        font.pixelSize: 13
                                                        elide: Text.ElideRight
                                                        width: 210
                                                    }
                                                }
                                            }

                                            MouseArea {
                                                id: cardMouse
                                                anchors.fill: parent
                                                hoverEnabled: true
                                                cursorShape: Qt.PointingHandCursor
                                                onClicked: {
                                                    Sfx.playButton();
                                                    RoomState.setVessel(vesselCard.modelData.id);
                                                }
                                            }
                                        }
                                    }
                                }
                            }

                            // -------------------------------------------------
                            // 2. CABIN & SCENERY
                            // -------------------------------------------------
                            Column {
                                visible: root.currentSection === "scenery"
                                width: parent.width
                                spacing: 12

                                Text {
                                    text: "Parallax Room Perspectives"
                                    color: Theme.parchmentWhite
                                    font.family: Theme.fontTitle
                                    font.pixelSize: 16
                                }

                                Grid {
                                    width: parent.width
                                    columns: 2
                                    columnSpacing: 10
                                    rowSpacing: 10

                                    Repeater {
                                        model: RoomsData.rooms

                                        Rectangle {
                                            id: roomCard
                                            required property var modelData
                                            required property int index
                                            width: (parent.width - 10) / 2
                                            height: 90
                                            radius: Theme.radiusSmall
                                            readonly property bool isCurrent: RoomState.roomIndex === index
                                            color: isCurrent ? Theme.surfaceSelected : (roomMouse.containsMouse ? Theme.surfaceHover : Theme.surfaceAlt)
                                            border.color: isCurrent ? Theme.accent : Theme.graphiteMuted
                                            border.width: isCurrent ? 2 : 1

                                            RowLayout {
                                                anchors.fill: parent
                                                anchors.margins: 10
                                                spacing: 10

                                                Rectangle {
                                                    width: 70
                                                    height: 70
                                                    radius: 4
                                                    color: Theme.voidBlack
                                                    border.color: Theme.graphiteMuted

                                                    Image {
                                                        anchors.fill: parent
                                                        source: Theme.asset(roomCard.modelData.layers[0].path)
                                                        fillMode: Image.PreserveAspectCrop
                                                    }
                                                }

                                                Column {
                                                    Layout.fillWidth: true
                                                    spacing: 2
                                                    Text {
                                                        text: roomCard.modelData.name
                                                        color: Theme.parchmentWhite
                                                        font.family: Theme.fontTitle
                                                        font.pixelSize: 15
                                                        font.bold: true
                                                    }
                                                    Text {
                                                        text: roomCard.modelData.description
                                                        color: Theme.pencilLight
                                                        font.family: Theme.fontBody
                                                        font.pixelSize: 14
                                                        elide: Text.ElideRight
                                                        width: 190
                                                    }
                                                    Text {
                                                        text: roomCard.modelData.layers.length + " Parallax Plates"
                                                        color: Theme.accent
                                                        font.family: Theme.fontBody
                                                        font.pixelSize: 13
                                                    }
                                                }
                                            }

                                            MouseArea {
                                                id: roomMouse
                                                anchors.fill: parent
                                                hoverEnabled: true
                                                cursorShape: Qt.PointingHandCursor
                                                onClicked: {
                                                    Sfx.playButton();
                                                    RoomState.setRoom(roomCard.modelData.id);
                                                }
                                            }
                                        }
                                    }
                                }

                                CharcoalButton {
                                    text: "Cycle Wallpaper / Sky Layer (SUPER + W)"
                                    isChoice: true
                                    fontSize: 16
                                    onClicked: {
                                        Sfx.playButton();
                                        Quickshell.execDetached(["slay-wall-cycle"]);
                                    }
                                }
                            }

                            // -------------------------------------------------
                            // 3. LIVING PENCIL & SHADERS
                            // -------------------------------------------------
                            Column {
                                visible: root.currentSection === "shaders"
                                width: parent.width
                                spacing: 14

                                SlaySlider {
                                    width: parent.width
                                    label: "Pencil Line Boil Intensity"
                                    icon: "pencil"
                                    value: RoomState.shaderIntensity
                                    from: 0.0
                                    to: 1.0
                                    onValueModified: function(val) { RoomState.shaderIntensity = val; }
                                }

                                SlaySlider {
                                    width: parent.width
                                    label: "Vignette Darkening"
                                    icon: "moon"
                                    value: RoomState.vignetteIntensity
                                    from: 0.0
                                    to: 1.0
                                    onValueModified: function(val) { RoomState.vignetteIntensity = val; }
                                }

                                RowLayout {
                                    width: parent.width
                                    Text {
                                        text: "Shader Active (12 FPS line animation)"
                                        color: Theme.parchment
                                        font.family: Theme.fontBody
                                        font.pixelSize: 20
                                        Layout.fillWidth: true
                                    }
                                    CharcoalButton {
                                        text: RoomState.shaderEnabled ? "Enabled" : "Disabled"
                                        implicitWidth: 100
                                        active: RoomState.shaderEnabled
                                        onClicked: RoomState.shaderEnabled = !RoomState.shaderEnabled
                                    }
                                }
                            }

                            // -------------------------------------------------
                            // 4. AUDIO & VOICE BUS
                            // -------------------------------------------------
                            Column {
                                visible: root.currentSection === "audio"
                                width: parent.width
                                spacing: 14

                                SlaySlider {
                                    width: parent.width
                                    label: "Master Output Volume (PipeWire)"
                                    icon: "speaker"
                                    value: Audio.volume
                                    from: 0.0
                                    to: 1.0
                                    onValueModified: function(val) { Audio.setVolume(val); }
                                }

                                SlaySlider {
                                    width: parent.width
                                    label: "Microphone Input Volume"
                                    icon: "mic"
                                    value: Audio.inputVolume
                                    from: 0.0
                                    to: 1.0
                                    onValueModified: function(val) { Audio.setInputVolume(val); }
                                }

                                RowLayout {
                                    width: parent.width
                                    Text {
                                        text: "Jonathan Sims Voice Quips"
                                        color: Theme.parchment
                                        font.family: Theme.fontBody
                                        font.pixelSize: 20
                                        Layout.fillWidth: true
                                    }
                                    CharcoalButton {
                                        text: VoiceBus.voiceMuted ? "Muted" : "Active"
                                        implicitWidth: 100
                                        active: !VoiceBus.voiceMuted
                                        onClicked: VoiceBus.voiceMuted = !VoiceBus.voiceMuted
                                    }
                                }

                                CharcoalButton {
                                    text: "Trigger Voice Line Sample (SUPER + X)"
                                    isChoice: true
                                    fontSize: 16
                                    onClicked: {
                                        VoiceBus.quip("Narrator", "You're on a path in the woods, and at the end of that path is a cabin.");
                                    }
                                }
                            }

                            // -------------------------------------------------
                            // 5. DISPLAYS & SCALE
                            // -------------------------------------------------
                            Column {
                                visible: root.currentSection === "displays"
                                width: parent.width
                                spacing: 12

                                Text {
                                    text: "Active Hyprland Display"
                                    color: Theme.parchmentWhite
                                    font.family: Theme.fontTitle
                                    font.pixelSize: 16
                                }

                                Rectangle {
                                    width: parent.width
                                    height: 70
                                    radius: Theme.radiusSmall
                                    color: Theme.surfaceAlt
                                    border.color: Theme.graphiteMuted

                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.margins: 12
                                        spacing: 12

                                        Text { text: "🖥️"; font.pixelSize: 24 }
                                        Column {
                                            Layout.fillWidth: true
                                            Text {
                                                text: (root.screen ? root.screen.name : "Display") + " — " + (root.screen ? root.screen.width : 1920) + "x" + (root.screen ? root.screen.height : 1080)
                                                color: Theme.parchmentWhite
                                                font.family: Theme.fontTitle
                                                font.pixelSize: 16
                                                font.bold: true
                                            }
                                            Text {
                                                text: "Layer-Shell backend: Wayland WlrLayershell (Hyprland)"
                                                color: Theme.pencilLight
                                                font.family: Theme.fontBody
                                                font.pixelSize: 14
                                            }
                                        }
                                    }
                                }
                            }

                            // -------------------------------------------------
                            // 6. KEYBINDS GRIMOIRE
                            // -------------------------------------------------
                            Column {
                                visible: root.currentSection === "keybinds"
                                width: parent.width
                                spacing: 8

                                Repeater {
                                    model: [
                                        { chord: "SUPER + Return", desc: "Launch Kitty Terminal (Charcoal & Parchment)" },
                                        { chord: "SUPER + Space", desc: "Open Slay the Princess App Launcher" },
                                        { chord: "SUPER + Escape", desc: "Open Quick Settings Sidebar" },
                                        { chord: "SUPER + comma", desc: "Open Slaytheland Customization Hub" },
                                        { chord: "SUPER + K", desc: "Toggle Keybind Grimoire Modal" },
                                        { chord: "SUPER + W", desc: "Cycle Wallpaper & Sky Plate" },
                                        { chord: "SUPER + R", desc: "Cycle Room Perspective" },
                                        { chord: "SUPER + G", desc: "Toggle Princess Companion Presence" },
                                        { chord: "SUPER + X", desc: "Trigger Visual Novel Dialogue Quote" },
                                        { chord: "SUPER + Q", desc: "Close Active Window (killactive)" },
                                        { chord: "SUPER + L", desc: "Lock Screen with Hyprlock" }
                                    ]

                                    Rectangle {
                                        id: bindItem
                                        required property var modelData
                                        width: parent.width
                                        height: 38
                                        radius: Theme.radiusSmall
                                        color: Theme.surfaceAlt
                                        border.color: Theme.graphiteMuted

                                        RowLayout {
                                            anchors.fill: parent
                                            anchors.margins: 8
                                            spacing: 12

                                            Rectangle {
                                                Layout.preferredHeight: 22
                                                Layout.preferredWidth: 140
                                                radius: 3
                                                color: Theme.voidBlack
                                                border.color: Theme.accent

                                                Text {
                                                    anchors.centerIn: parent
                                                    text: bindItem.modelData.chord
                                                    color: Theme.parchmentWhite
                                                    font.family: Theme.fontTitle
                                                    font.pixelSize: 12
                                                }
                                            }

                                            Text {
                                                Layout.fillWidth: true
                                                text: bindItem.modelData.desc
                                                color: Theme.parchment
                                                font.family: Theme.fontBody
                                                font.pixelSize: 16
                                            }
                                        }
                                    }
                                }
                            }

                            // -------------------------------------------------
                            // 7. WINDOW RULES & ANIMATIONS
                            // -------------------------------------------------
                            Column {
                                visible: root.currentSection === "windows"
                                width: parent.width
                                spacing: 12

                                Text {
                                    text: "Hyprland Dual-Tone Active Borders"
                                    color: Theme.parchmentWhite
                                    font.family: Theme.fontTitle
                                    font.pixelSize: 16
                                }

                                Rectangle {
                                    width: parent.width
                                    height: 50
                                    radius: Theme.radiusSmall
                                    color: Theme.surfaceAlt
                                    border.color: Theme.accent
                                    border.width: 2

                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.margins: 10
                                        Text { text: "Active Border Gradient: col.active_border = rgba(c72c41ee) rgba(801336ee) 45deg"; color: Theme.parchment; font.family: Theme.fontBody; font.pixelSize: 17 }
                                    }
                                }

                                Text {
                                    text: "Tension Bezier Curves: sharpEase = 0.16, 1, 0.3, 1 | tension = 0.2, 0.8, 0.2, 1"
                                    color: Theme.pencilLight
                                    font.family: Theme.fontBody
                                    font.pixelSize: 16
                                }
                            }

                            // -------------------------------------------------
                            // 8. HYPRLOCK
                            // -------------------------------------------------
                            Column {
                                visible: root.currentSection === "lock"
                                width: parent.width
                                spacing: 12

                                Text {
                                    text: "Direct-to-Desktop Slay the Princess Hyprlock"
                                    color: Theme.parchmentWhite
                                    font.family: Theme.fontTitle
                                    font.pixelSize: 16
                                }

                                Rectangle {
                                    width: parent.width
                                    height: 80
                                    radius: Theme.radiusSmall
                                    color: Theme.surfaceAlt
                                    border.color: Theme.graphiteMuted

                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.margins: 12
                                        spacing: 12

                                        Text { text: "🔒"; font.pixelSize: 24 }
                                        Column {
                                            Layout.fillWidth: true
                                            Text {
                                                text: "Hyprlock configuration active: ~/.config/hypr/hyprlock.conf"
                                                color: Theme.parchmentWhite
                                                font.family: Theme.fontTitle
                                                font.pixelSize: 15
                                                font.bold: true
                                            }
                                            Text {
                                                text: "Direct boot bypasses display manager. Press SUPER + L anytime to lock."
                                                color: Theme.pencilLight
                                                font.family: Theme.fontBody
                                                font.pixelSize: 14
                                            }
                                        }
                                    }
                                }

                                CharcoalButton {
                                    text: "Test Hyprlock Now (SUPER + L)"
                                    isChoice: true
                                    fontSize: 16
                                    onClicked: Quickshell.execDetached(["hyprlock"])
                                }
                            }

                            // -------------------------------------------------
                            // 9. ABOUT & SYSTEM HEALTH
                            // -------------------------------------------------
                            Column {
                                visible: root.currentSection === "about"
                                width: parent.width
                                spacing: 12

                                Rectangle {
                                    width: parent.width
                                    height: 100
                                    radius: Theme.radiusSmall
                                    color: Theme.surfaceAlt
                                    border.color: Theme.graphiteMuted

                                    Column {
                                        anchors.fill: parent
                                        anchors.margins: 12
                                        spacing: 4

                                        Text {
                                            text: "slaytheland v1.2.0 (Ryoku Architecture Edition)"
                                            color: Theme.parchmentWhite
                                            font.family: Theme.fontTitle
                                            font.pixelSize: 17
                                            font.bold: true
                                        }
                                        Text {
                                            text: "Session Loop Duration: " + Session.uptimeString
                                            color: Theme.accent
                                            font.family: Theme.fontBody
                                            font.pixelSize: 16
                                        }
                                        Text {
                                            text: "Host: " + Session.hostname + " | Linux " + Session.kernel
                                            color: Theme.pencilLight
                                            font.family: Theme.fontBody
                                            font.pixelSize: 14
                                        }
                                    }
                                }

                                CharcoalButton {
                                    text: "Run slay-doctor System Health Suite"
                                    isChoice: true
                                    fontSize: 16
                                    onClicked: Quickshell.execDetached(["kitty", "--hold", "-e", "slay-doctor"])
                                }
                            }
                        }
                    }
                }
            }

            // =================================================================
            // RIGHT: Live Feedback Preview Dock (Ryoku Hub Live Preview Pattern)
            // =================================================================
            Item {
                Layout.preferredWidth: 240
                Layout.fillHeight: true

                Rectangle {
                    anchors.fill: parent
                    color: Theme.voidBlack
                    radius: Theme.radiusSmall
                    border.color: Theme.graphiteMuted
                }

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 14
                    spacing: 12

                    Text {
                        text: "LIVE PREVIEW"
                        color: Theme.parchmentWhite
                        font.family: Theme.fontTitle
                        font.pixelSize: 14
                        font.bold: true
                    }

                    // Princess Portrait Preview
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 180
                        radius: Theme.radiusSmall
                        color: Theme.surfaceAlt
                        border.color: Theme.accent
                        border.width: 2

                        Image {
                            anchors.fill: parent
                            anchors.margins: 4
                            source: RoomState.currentVessel ? Theme.asset(RoomState.currentVessel.sprite) : ""
                            fillMode: Image.PreserveAspectFit
                        }
                    }

                    Text {
                        text: RoomState.currentVessel ? RoomState.currentVessel.name : "The Princess"
                        color: Theme.parchmentWhite
                        font.family: Theme.fontTitle
                        font.pixelSize: 16
                        font.bold: true
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Text {
                        text: RoomState.currentVessel ? RoomState.currentVessel.title : ""
                        color: Theme.accent
                        font.family: Theme.fontBody
                        font.pixelSize: 14
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: Theme.graphiteMuted
                    }

                    // Room Scene Thumbnail
                    Text {
                        text: "CURRENT PERSPECTIVE"
                        color: Theme.pencilLight
                        font.family: Theme.fontTitle
                        font.pixelSize: 12
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 90
                        radius: 4
                        color: Theme.surfaceAlt
                        border.color: Theme.graphiteMuted

                        Image {
                            anchors.fill: parent
                            anchors.margins: 2
                            source: RoomState.currentRoom ? Theme.asset(RoomState.currentRoom.layers[0].path) : ""
                            fillMode: Image.PreserveAspectCrop
                        }
                    }

                    Text {
                        text: RoomState.currentRoom ? RoomState.currentRoom.name : "The Woods"
                        color: Theme.parchment
                        font.family: Theme.fontBody
                        font.pixelSize: 15
                        elide: Text.ElideRight
                    }

                    Item { Layout.fillHeight: true }

                    // Accent Palette Chip
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 8
                        Rectangle {
                            width: 20
                            height: 20
                            radius: 10
                            color: Theme.accent
                            border.color: Theme.parchmentWhite
                            border.width: 1
                        }
                        Text {
                            text: "Mood Accent Active"
                            color: Theme.pencilLight
                            font.family: Theme.fontBody
                            font.pixelSize: 14
                        }
                    }
                }
            }
        }
    }
}
