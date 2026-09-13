pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Hyprland
import "lib/screens.js" as Screens

Singleton {
    id: root

    readonly property var screens: Screens.uniqueByName(Quickshell.screens)

    function forScreen(screen) {
        return Screens.sliceForScreen(states.instances, screen);
    }

    function forActive() {
        const mon = Hyprland.focusedMonitor;
        const slice = Screens.sliceForName(states.instances, mon && mon.name ? mon.name : "");
        if (slice) return slice;
        return states.instances.length > 0 ? states.instances[0] : null;
    }

    // Global toggle functions
    function toggleLauncher() {
        var s = forActive();
        if (s) {
            s.launcherOpen = !s.launcherOpen;
            if (s.launcherOpen) {
                s.quicksettingsOpen = false;
                s.hubOpen = false;
            }
        }
    }

    function toggleQuicksettings() {
        var s = forActive();
        if (s) {
            s.quicksettingsOpen = !s.quicksettingsOpen;
            if (s.quicksettingsOpen) {
                s.launcherOpen = false;
                s.hubOpen = false;
            }
        }
    }

    function toggleHub() {
        var s = forActive();
        if (s) {
            s.hubOpen = !s.hubOpen;
            if (s.hubOpen) {
                s.launcherOpen = false;
                s.quicksettingsOpen = false;
            }
        }
    }

    function toggleCheatsheet() {
        var s = forActive();
        if (s) {
            s.cheatsheetOpen = !s.cheatsheetOpen;
            if (s.cheatsheetOpen) {
                s.launcherOpen = false;
                s.quicksettingsOpen = false;
                s.hubOpen = false;
            }
        }
    }

    function toggleCompanion() {
        var s = forActive();
        if (s) s.companionVisible = !s.companionVisible;
    }

    function toggleDialogue() {
        var s = forActive();
        if (s) s.dialogueVisible = !s.dialogueVisible;
    }

    function closeAll() {
        for (var i = 0; i < states.instances.length; i++) {
            var inst = states.instances[i];
            inst.launcherOpen = false;
            inst.quicksettingsOpen = false;
            inst.hubOpen = false;
            inst.cheatsheetOpen = false;
        }
    }

    Variants {
        id: states
        model: root.screens

        PersistentProperties {
            id: slice
            required property var modelData

            property bool launcherOpen: false
            property bool quicksettingsOpen: false
            property bool hubOpen: false
            property bool cheatsheetOpen: false
            property bool companionVisible: true
            property bool dialogueVisible: false
        }
    }
}
