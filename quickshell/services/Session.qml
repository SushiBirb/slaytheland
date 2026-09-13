pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    readonly property string user: Quickshell.env("USER") || "slayer"
    property string host: "archlinux"
    property real uptimeSecs: 0

    readonly property string uptimeText: {
        var t = Math.max(0, Math.floor(root.uptimeSecs));
        var d = Math.floor(t / 86400);
        var h = Math.floor((t % 86400) / 3600);
        var m = Math.floor((t % 3600) / 60);
        if (d > 0)
            return d + "d " + h + "h";
        if (h > 0)
            return h + "h " + m + "m";
        return m + "m";
    }

    FileView {
        id: upFile
        path: "/proc/uptime"
        blockLoading: true
        printErrors: false
        onLoaded: {
            var f = parseFloat((upFile.text() || "0").trim().split(/\s+/)[0]);
            if (!isNaN(f))
                root.uptimeSecs = f;
        }
    }

    FileView {
        id: hostFile
        path: "/etc/hostname"
        blockLoading: true
        printErrors: false
        onLoaded: {
            var h = (hostFile.text() || "").trim();
            if (h.length)
                root.host = h;
        }
    }

    Timer {
        interval: 10000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: upFile.reload()
    }

    Process {
        id: execProc
    }

    function lock() {
        execProc.command = ["hyprlock"];
        execProc.running = true;
    }

    function logout() {
        execProc.command = ["hyprctl", "dispatch", "exit"];
        execProc.running = true;
    }

    function reboot() {
        execProc.command = ["systemctl", "reboot"];
        execProc.running = true;
    }

    function shutdown() {
        execProc.command = ["systemctl", "poweroff"];
        execProc.running = true;
    }
}
