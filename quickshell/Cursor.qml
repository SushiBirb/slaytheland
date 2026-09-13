pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick
import "."

Singleton {
    id: root

    property real gx: 640
    property real gy: 400
    readonly property bool ready: gx >= 0

    Process {
        id: cursorProc
        running: true
        command: ["python3", "-u", "-c",
            "import socket, os, sys, time\n" +
            "sig = os.environ.get('HYPRLAND_INSTANCE_SIGNATURE', '')\n" +
            "if not sig:\n" +
            "    hypr_dir = f'/run/user/{os.getuid()}/hypr'\n" +
            "    if os.path.exists(hypr_dir):\n" +
            "        dirs = [d for d in os.listdir(hypr_dir) if os.path.isdir(os.path.join(hypr_dir, d))]\n" +
            "        if dirs:\n" +
            "            sig = sorted(dirs)[-1]\n" +
            "path = f'/run/user/{os.getuid()}/hypr/{sig}/.socket.sock'\n" +
            "ppid = os.getppid()\n" +
            "last = ''\n" +
            "idle = 0\n" +
            "while True:\n" +
            "    if os.getppid() != ppid:\n" +
            "        sys.exit(0)\n" +
            "    s = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)\n" +
            "    try:\n" +
            "        s.connect(path)\n" +
            "        s.sendall(b'cursorpos')\n" +
            "        data = b''\n" +
            "        while True:\n" +
            "            c = s.recv(256)\n" +
            "            if not c: break\n" +
            "            data += c\n" +
            "        pos = data.decode('utf-8', errors='ignore').strip()\n" +
            "        if pos != last:\n" +
            "            last = pos\n" +
            "            idle = 0\n" +
            "            print(pos, flush=True)\n" +
            "        else:\n" +
            "            idle += 1\n" +
            "    except Exception:\n" +
            "        idle += 1\n" +
            "    finally:\n" +
            "        try: s.close()\n" +
            "        except Exception: pass\n" +
            "    if idle < 20: delay = 0.03\n" +
            "    elif idle < 60: delay = 0.1\n" +
            "    elif idle < 240: delay = 0.25\n" +
            "    else: delay = 0.5\n" +
            "    time.sleep(delay)"]
        stdout: SplitParser {
            splitMarker: "\n"
            onRead: function(data) {
                var parts = data.trim().split(",");
                if (parts.length >= 2) {
                    var cx = parseFloat(parts[0]);
                    var cy = parseFloat(parts[1]);
                    if (!isNaN(cx) && !isNaN(cy)) {
                        root.gx = cx;
                        root.gy = cy;
                        RoomState.updateGlobalCursor(cx, cy);
                    }
                }
            }
        }
    }
}
