import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import ".."
import "../services"
import "../widgets"

Item {
    id: root

    required property var screen

    readonly property var stateSlice: ShellState.forScreen(screen)
    readonly property bool isOpen: stateSlice ? stateSlice.launcherOpen : false

    anchors.fill: parent
    visible: opacity > 0.0
    opacity: root.isOpen ? 1.0 : 0.0
    Behavior on opacity { NumberAnimation { duration: 200 } }

    onIsOpenChanged: {
        if (root.isOpen) {
            searchInput.text = "";
            searchInput.forceActiveFocus();
            VoiceBus.onLauncherOpened();
        }
    }

    // Modal Dim
    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0.5)

        MouseArea {
            anchors.fill: parent
            onClicked: ShellState.toggleLauncher()
        }
    }

    // Default applications list
    readonly property var defaultApps: [
        { name: "Kitty Terminal", exec: "kitty", icon: "terminal", desc: "Open hand-drawn parchment terminal" },
        { name: "Slay the Princess Hub", exec: ":hub", icon: "crown", desc: "Open Customization Studio" },
        { name: "The Woods (Room)", exec: ":room woods", icon: "tree", desc: "Switch background to Path in the Woods" },
        { name: "The Cabin (Room)", exec: ":room cabin_exterior", icon: "home", desc: "Switch background to Cabin Exterior" },
        { name: "The Basement (Room)", exec: ":room distant_basement", icon: "door", desc: "Descend into the basement" },
        { name: "Hear the Narrator", exec: ":talk", icon: "quote", desc: "Listen to the voices in your head" },
        { name: "Cycle Wallpapers", exec: ":wall", icon: "image", desc: "Crossfade to next CG artwork" },
        { name: "Lock Session", exec: "hyprlock", icon: "lock", desc: "Turn back and face the mirror" }
    ]

    property var filteredApps: {
        var query = searchInput.text.trim().toLowerCase();
        if (query === "") return root.defaultApps;

        var results = [];
        for (var i = 0; i < root.defaultApps.length; i++) {
            var app = root.defaultApps[i];
            if (app.name.toLowerCase().indexOf(query) >= 0 || app.desc.toLowerCase().indexOf(query) >= 0 || app.exec.indexOf(query) >= 0) {
                results.push(app);
            }
        }
        return results;
    }

    Process {
        id: execProc
    }

    function launch(cmd) {
        ShellState.toggleLauncher();
        if (cmd === ":hub") {
            ShellState.toggleHub();
        } else if (cmd === ":talk") {
            VoiceBus.triggerRandomQuote();
        } else if (cmd === ":wall") {
            Quickshell.execDetached(["bash", "-c", "for p in \"$HOME/slaytheland/scripts/wall-cycle.sh\" \"$HOME/Projects/slaytheland/scripts/wall-cycle.sh\" \"/home/arch/slaytheland/scripts/wall-cycle.sh\"; do if [ -f \"$p\" ]; then exec \"$p\"; fi; done"]);
        } else if (cmd.indexOf(":room ") === 0) {
            var rId = cmd.substring(6).trim();
            RoomState.setRoom(rId);
        } else if (cmd.indexOf(":vessel ") === 0) {
            var vId = cmd.substring(8).trim();
            RoomState.setVessel(vId);
        } else {
            var safeCmd = cmd.trim();
            if (/^[a-zA-Z0-9_\-\.\/\s]+$/.test(safeCmd)) {
                Quickshell.execDetached(["sh", "-c", safeCmd + " &"]);
            } else {
                console.log("Blocked potentially unsafe launcher command:", safeCmd);
            }
        }
    }

    // Centered Frame Container
    Item {
        id: container
        width: 540
        height: 440
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

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 12

            // Title & Search Prompt
            Text {
                text: "What will you do?..."
                color: Theme.parchmentWhite
                font.family: Theme.fontTitle
                font.pixelSize: 22
                font.bold: true
            }

            // Search Box Input
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 42
                radius: Theme.radiusSmall
                color: Theme.surfaceAlt
                border.color: searchInput.activeFocus ? Theme.accent : Theme.graphiteMuted
                border.width: searchInput.activeFocus ? 2 : 1

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    spacing: 8

                    Text {
                        text: "🗡️"
                        font.pixelSize: 16
                    }

                    TextInput {
                        id: searchInput
                        Layout.fillWidth: true
                        color: Theme.parchmentWhite
                        font.family: Theme.fontBody
                        font.pixelSize: 22
                        clip: true
                        selectByMouse: true
                        selectionColor: Theme.accent

                        Keys.onEscapePressed: ShellState.toggleLauncher()
                        Keys.onReturnPressed: {
                            if (root.filteredApps.length > 0) {
                                root.launch(root.filteredApps[0].exec);
                            }
                        }
                    }
                }
            }

            // Filtered Items List
            ListView {
                id: listView
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                spacing: 6
                model: root.filteredApps

                delegate: Rectangle {
                    id: itemCard
                    required property var modelData
                    required property int index

                    width: listView.width
                    height: 42
                    radius: Theme.radiusSmall
                    color: itemMouse.containsMouse ? Theme.surfaceHover : Theme.surfaceAlt
                    border.color: itemMouse.containsMouse ? Theme.accent : Theme.graphiteMuted
                    border.width: itemMouse.containsMouse ? 2 : 1

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 14
                        anchors.rightMargin: 14
                        spacing: 10

                        Text {
                            visible: itemMouse.containsMouse
                            text: "🗡️"
                            font.pixelSize: 14
                        }

                        Text {
                            text: itemCard.modelData.name
                            color: itemMouse.containsMouse ? Theme.parchmentWhite : Theme.parchment
                            font.family: Theme.fontTitle
                            font.pixelSize: 16
                            font.bold: true
                        }

                        Item { Layout.fillWidth: true }

                        Text {
                            text: itemCard.modelData.desc
                            color: Theme.pencilLight
                            font.family: Theme.fontBody
                            font.pixelSize: 16
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
                            root.launch(itemCard.modelData.exec);
                        }
                    }
                }
            }
        }
    }
}
