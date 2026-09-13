// Curated dialogue lines for Slay the Princess visual novel system
var dialogues = [
    {
        speaker: "The Narrator",
        text: "You're on a path in the woods, and at the end of that path is a cabin. And in the basement of that cabin is a Princess.",
        tone: "formal"
    },
    {
        speaker: "The Narrator",
        text: "You're here to slay her. If you don't, it will be the end of the world.",
        tone: "ominous"
    },
    {
        speaker: "The Narrator",
        text: "A pristine blade rests on the table. It's sharp, and it's your only weapon.",
        tone: "neutral"
    },
    {
        speaker: "Voice of the Hero",
        text: "Wait... are we really doing this? We don't even know who she is or what she did.",
        tone: "hesitant"
    },
    {
        speaker: "Voice of the Paranoid",
        text: "Our heart is beating too fast. Or is it slowing down?! We need to check our pulse right now!",
        tone: "anxious"
    },
    {
        speaker: "Voice of the Skeptic",
        text: "Does anything about this seem right to you? Why does he want us to kill her so badly?",
        tone: "calculating"
    },
    {
        speaker: "Voice of the Smitten",
        text: "She's breathtaking! Look at the tragic grace in her eyes. We must save her!",
        tone: "romantic"
    },
    {
        speaker: "Voice of the Stubborn",
        text: "Get back up! We aren't dying here. I don't care if she cuts us in half, swing again!",
        tone: "defiant"
    },
    {
        speaker: "Voice of the Opportunist",
        text: "Now this... this is an opportunity. If we play our cards right, we come out on top.",
        tone: "cunning"
    },
    {
        speaker: "Voice of the Hunted",
        text: "She's listening to our breathing. Every muscle in her body is coiled to strike. Run.",
        tone: "feral"
    },
    {
        speaker: "The Princess",
        text: "Are you just going to stand there staring? Or are you going to say something?",
        tone: "curious"
    },
    {
        speaker: "The Princess",
        text: "I hope we find each other again in whatever comes next.",
        tone: "tender"
    },
    {
        speaker: "The Witch",
        text: "You turned your back on me. Did you really think I wouldn't bite?",
        tone: "venomous"
    },
    {
        speaker: "The Damsel",
        text: "I want whatever you want! As long as we're together, everything is wonderful!",
        tone: "cheerful"
    },
    {
        speaker: "The Nightmare",
        text: "Look at me. Don't close your eyes. If you close your eyes, you won't see what's coming.",
        tone: "horror"
    }
];

function getRandomDialogue() {
    var idx = Math.floor(Math.random() * dialogues.length);
    return dialogues[idx];
}

function getDialogueForSpeaker(spk) {
    var matches = [];
    for (var i = 0; i < dialogues.length; i++) {
        if (dialogues[i].speaker.toLowerCase().indexOf(spk.toLowerCase()) >= 0) {
            matches.push(dialogues[i]);
        }
    }
    if (matches.length === 0) return getRandomDialogue();
    return matches[Math.floor(Math.random() * matches.length)];
}

if (typeof module !== "undefined" && module.exports)
    module.exports = { dialogues, getRandomDialogue, getDialogueForSpeaker };
