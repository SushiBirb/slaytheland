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

    function triggerQuote(speaker, text) {
        root.currentSpeaker = speaker;
        root.currentText = text;
        root.isTalking = true;
        root.dialogueTriggered(speaker, text);
    }

    function triggerRandomQuote() {
        var d = DialogueData.getRandomDialogue();
        if (d) {
            triggerQuote(d.speaker, d.text);
        }
    }

    function triggerSpeaker(spk) {
        var d = DialogueData.getDialogueForSpeaker(spk);
        if (d) {
            triggerQuote(d.speaker, d.text);
        }
    }

    // System event handlers
    function onStartup() {
        triggerQuote("The Narrator", "You're on a path in the woods, and at the end of that path is a cabin.");
    }

    function onLauncherOpened() {
        triggerQuote("Voice of the Opportunist", "Now this... this is an opportunity. Let's make sure we come out on top.");
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
        triggerQuote("The Narrator", "The interior of the cabin is clean and sparse. There's a door leading to the basement.");
    }

    function onShutdown() {
        triggerQuote("The Princess", "I hope we find each other again in whatever comes next.");
    }
}
