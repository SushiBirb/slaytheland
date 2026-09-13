pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Singleton {
    id: root

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property var source: Pipewire.defaultAudioSource
    readonly property var nodes: (Pipewire.nodes && Pipewire.ready) ? Pipewire.nodes.values : []

    readonly property real volume: sink && sink.audio ? sink.audio.volume : 0.0
    readonly property bool muted: sink && sink.audio ? sink.audio.muted : false

    readonly property real inputVolume: source && source.audio ? source.audio.volume : 0.0
    readonly property bool inputMuted: source && source.audio ? source.audio.muted : false

    function typeOf(n) {
        return (n && typeof PwNodeType !== "undefined") ? PwNodeType.toString(n.type) : "";
    }

    function isOutput(n) { return !!(n && n.isSink && !n.isStream && n.audio); }
    function isInput(n) { return !!(n && !n.isSink && !n.isStream && n.audio); }
    function isPlayStream(n) {
        return !!(n && n.isStream && n.audio && root.typeOf(n).indexOf("In") < 0);
    }

    readonly property var liveOutputs: root.dedupByName(root.nodes.filter(root.isOutput))
    readonly property var liveInputs: root.dedupByName(root.nodes.filter(root.isInput))
    readonly property var liveStreams: root.nodes.filter(root.isPlayStream)

    function dedupByName(list) {
        var seen = ({});
        var out = [];
        for (var i = 0; i < list.length; i++) {
            var n = list[i];
            var key = (n && n.name) ? ("" + n.name) : ("__i" + i);
            if (seen[key])
                continue;
            seen[key] = true;
            out.push(n);
        }
        return out;
    }

    // Settled snapshots for crash-free repeater rebuilding
    property var outputs: []
    property var inputs: []
    property var streams: []

    function syncAudioLists() {
        root.outputs = root.liveOutputs.slice();
        root.inputs = root.liveInputs.slice();
        root.streams = root.liveStreams.slice();
    }

    Timer {
        id: listSettle
        interval: 75
        repeat: false
        onTriggered: root.syncAudioLists()
    }

    onLiveOutputsChanged: listSettle.restart()
    onLiveInputsChanged: listSettle.restart()
    onLiveStreamsChanged: listSettle.restart()

    Component.onCompleted: root.syncAudioLists()

    function setOutput(n) { if (n) Pipewire.preferredDefaultAudioSink = n; }
    function setInput(n) { if (n) Pipewire.preferredDefaultAudioSource = n; }

    function setVolume(val) {
        if (sink && sink.audio) {
            sink.audio.volume = Math.max(0.0, Math.min(1.5, val));
        }
    }

    function setInputVolume(val) {
        if (source && source.audio) {
            source.audio.volume = Math.max(0.0, Math.min(1.5, val));
        }
    }

    function toggleMute() {
        if (sink && sink.audio) {
            sink.audio.muted = !sink.audio.muted;
        }
    }

    function toggleInputMute() {
        if (source && source.audio) {
            source.audio.muted = !source.audio.muted;
        }
    }

    PwObjectTracker {
        objects: [root.sink, root.source].filter(Boolean)
            .concat(root.outputs).concat(root.inputs).concat(root.streams)
    }

    function nodeLabel(n) {
        if (!n) return "";
        var p = n.properties || ({});
        return n.description || n.nickname || p["node.description"] || n.name || "Audio device";
    }
}
