pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import "data/dialogue.js" as DialogueData

Singleton {
    id: root

    property bool voiceMuted: false
    property bool isTalking: false
    property string currentSpeaker: "The Narrator"
    property string currentText: ""
    property string currentTone: "formal"

    signal dialogueTriggered(string speaker, string text)

    Process {
        id: voiceProc
        onExited: {
            root.isTalking = false;
        }
    }

    function stopVoice() {
        voiceProc.running = false;
        root.isTalking = false;
    }

    function triggerQuote(speaker, text, audioFile) {
        root.currentSpeaker = speaker;
        root.currentText = text;
        root.isTalking = true;
        root.dialogueTriggered(speaker, text);

        if (!root.voiceMuted && audioFile && audioFile !== "") {
            voiceProc.running = false;
            var assetUrl = Theme.asset(audioFile).toString();
            var fullPath = assetUrl.replace(/^file:\/\//, "");
            voiceProc.command = ["pw-play", fullPath];
            voiceProc.running = true;
        }
    }

    function triggerRandomQuote() {
        var d = DialogueData.getRandomDialogue();
        if (d) {
            triggerQuote(d.speaker, d.text, d.audioFile);
        }
    }

    function triggerSpeaker(spk) {
        var d = DialogueData.getDialogueForSpeaker(spk);
        if (d) {
            triggerQuote(d.speaker, d.text, d.audioFile);
        }
    }

    // System event handlers
    function onStartup() {
        triggerQuote(
            "The Narrator",
            "You're on a path in the woods, and at the end of that path is a cabin. And in the basement of that cabin is a princess.",
            "audio/voices/narrator_woods_1.flac"
        );
    }

    function onLauncherOpened() {
        triggerQuote(
            "Voice of the Hero",
            "Wait... are we really doing this? We don't even know who she is or what she did.",
            "audio/voices/hero_hesitant.flac"
        );
    }

    function onBatteryCritical() {
        triggerQuote("Voice of the Paranoid", "Our heart is slowing down... is it stopping?! We need to plug in right now!");
    }

    function onWorkspaceHero() {
        triggerQuote("Voice of the Hero", "Let's see what we're dealing with.");
    }

    function onHeavyLoad() {
        triggerQuote("Voice of the Hunted", "Something is coming. It's fast, and it's hungry.");
    }

    function onMusicPlayed() {
        triggerQuote("Voice of the Smitten", "Listen to that melody... isn't she magnificent?");
    }

    function onLockOpened() {
        triggerQuote(
            "The Narrator",
            "A pristine blade rests on the table. It's sharp, and it's your only weapon.",
            "audio/voices/narrator_cabin_blade.flac"
        );
    }

    function onShutdown() {
        triggerQuote("The Princess", "I hope we find each other again in whatever comes next.");
    }
}
