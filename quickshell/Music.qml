pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris

Singleton {
    id: root

    property bool enabled: true
    property bool isPlaying: false
    property real volume: 0.5
    property int currentIndex: 0

    readonly property var playlist: [
        { name: "The Long Quiet", file: "audio/music/The Long Quiet.flac" },
        { name: "The Cabin (Stranger)", file: "audio/music/The Stranger Cabin.flac" },
        { name: "The Thorn Theme", file: "audio/music/The Thorn Loop.flac" },
        { name: "The Tower Theme", file: "audio/music/The Tower.flac" },
        { name: "The Witch Theme", file: "audio/music/The Witch.flac" },
        { name: "Slay the Princess — Main Menu", file: "audio/music/main_menu.flac" }
    ]

    readonly property string currentTitle: playlist[currentIndex] ? playlist[currentIndex].name : "Colin Stetson — Slay the Princess"

    // External MPRIS integration
    readonly property var mprisPlayers: Mpris.players.values
    readonly property var activeMpris: mprisPlayers.length > 0 ? mprisPlayers[0] : null
    readonly property bool hasExternalMpris: activeMpris !== null && activeMpris.playbackState === MprisPlaybackState.Playing

    readonly property string displayTitle: hasExternalMpris && activeMpris.trackTitle !== "" ? activeMpris.trackTitle : currentTitle
    readonly property string displayArtist: hasExternalMpris && activeMpris.trackArtist !== "" ? activeMpris.trackArtist : "Colin Stetson"

    Process {
        id: playerProc
        onExited: {
            if (root.isPlaying) {
                root.next();
            }
        }
    }

    function play() {
        if (hasExternalMpris && activeMpris) {
            activeMpris.play();
            return;
        }
        var track = playlist[currentIndex];
        if (!track) return;
        var fullPath = Theme.assetPath(track.file);
        playerProc.command = ["pw-play", "--volume", "" + root.volume, fullPath];
        playerProc.running = true;
        root.isPlaying = true;
    }

    function pause() {
        if (hasExternalMpris && activeMpris) {
            activeMpris.pause();
            return;
        }
        playerProc.running = false;
        root.isPlaying = false;
    }

    function togglePlay() {
        if (hasExternalMpris && activeMpris) {
            activeMpris.togglePlaying();
            return;
        }
        if (root.isPlaying) {
            root.pause();
        } else {
            root.play();
        }
    }

    function next() {
        if (hasExternalMpris && activeMpris) {
            activeMpris.next();
            return;
        }
        playerProc.running = false;
        root.currentIndex = (root.currentIndex + 1) % root.playlist.length;
        if (root.isPlaying) {
            root.play();
        }
    }

    function prev() {
        if (hasExternalMpris && activeMpris) {
            activeMpris.previous();
            return;
        }
        playerProc.running = false;
        root.currentIndex = (root.currentIndex - 1 + root.playlist.length) % root.playlist.length;
        if (root.isPlaying) {
            root.play();
        }
    }
}
