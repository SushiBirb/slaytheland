pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property bool enabled: true
    property real volume: 0.7

    Process {
        id: proc
    }

    function playFile(relPath) {
        if (!root.enabled) return;
        var fullPath = Theme.assetPath(relPath);
        proc.command = ["pw-play", "--volume", "" + root.volume, fullPath];
        proc.running = true;
    }

    function playButton() {
        playFile("audio/sfx/chain_1.flac");
    }

    function playBlade() {
        playFile("audio/sfx/door_bedroom.flac");
    }

    function playGlass() {
        playFile("audio/sfx/Glass_1.flac");
    }

    function playDoor() {
        playFile("audio/sfx/door_close.flac");
    }

    function playChain() {
        playFile("audio/sfx/chain_1.flac");
    }

    function playFootstep() {
        playFile("audio/sfx/footsteps_creaky.flac");
    }
}
