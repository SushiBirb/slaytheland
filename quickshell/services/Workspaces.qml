pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

// Reliable workspace tracker & dispatcher for slaytheland,
// compatible with both Hyprland Lua configuration and classic Hyprland.
Singleton {
    id: root

    property int probedId: -1
    readonly property int activeId: Hyprland.focusedWorkspace
        ? Hyprland.focusedWorkspace.id
        : (probedId >= 1 ? probedId : 1)

    property bool hyprUsesLua: true

    function probe() {
        proc.running = true;
    }

    Process {
        id: proc
        command: ["hyprctl", "activeworkspace", "-j"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    root.probedId = JSON.parse(this.text).id;
                } catch (e) {}
            }
        }
    }

    Process {
        id: luaProbe
        command: ["bash", "-c", "hyprctl dispatch 'hl.dsp.focus({ workspace = \"e+0\" })' 2>&1 | grep -qix ok && echo lua || echo classic"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                root.hyprUsesLua = (this.text.trim() === "lua");
            }
        }
    }

    function focusWorkspace(id) {
        root.probedId = id;
        if (hyprUsesLua) {
            Hyprland.dispatch("hl.dsp.focus({ workspace = " + id + " })");
            Quickshell.execDetached(["hyprctl", "dispatch", "hl.dsp.focus({ workspace = " + id + " })"]);
        } else {
            Hyprland.dispatch("workspace " + id);
            Quickshell.execDetached(["hyprctl", "dispatch", "workspace", "" + id]);
        }
    }

    // Re-seed on any workspace/monitor event
    readonly property var watched: ({
        workspace: true, workspacev2: true,
        focusedmon: true, focusedmonv2: true,
        moveworkspace: true, moveworkspacev2: true,
        createworkspace: true, createworkspacev2: true,
        destroyworkspace: true, destroyworkspacev2: true
    })

    Connections {
        target: Hyprland
        function onRawEvent(event) {
            if (root.watched[event.name]) {
                Qt.callLater(root.probe);
            }
        }
    }

    Component.onCompleted: {
        root.probe();
    }
}
