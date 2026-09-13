// Curated dialogue lines for Slay the Princess visual novel system
var dialogues = [
    {
        speaker: "The Narrator",
        text: "You're on a path in the woods, and at the end of that path is a cabin. And in the basement of that cabin is a Princess.",
        tone: "formal",
        audioFile: "audio/voices/narrator_woods_1.flac"
    },
    {
        speaker: "The Narrator",
        text: "You're here to slay her. If you don't, it will be the end of the world.",
        tone: "ominous",
        audioFile: "audio/voices/narrator_woods_2.flac"
    },
    {
        speaker: "The Narrator",
        text: "A pristine blade rests on the table. It's sharp, and it's your only weapon.",
        tone: "neutral",
        audioFile: "audio/voices/narrator_cabin_blade.flac"
    },
    {
        speaker: "The Narrator",
        text: "The stairs creak beneath your feet as you descend into the dark.",
        tone: "ominous",
        audioFile: "audio/voices/narrator_basement_stairs.flac"
    },
    {
        speaker: "Voice of the Hero",
        text: "Good. What we're being asked to do here is wrong. Better to wash our hands of this whole situation than to take part in it.",
        tone: "hesitant",
        audioFile: "audio/voices/hero_hesitant.flac"
    },
    {
        speaker: "Voice of the Hero",
        text: "Careful. Don't do anything reckless.",
        tone: "neutral",
        audioFile: "audio/voices/hero_dangerous.flac"
    },
    {
        speaker: "Voice of the Paranoid",
        text: "Our heart is beating too fast. Or is it slowing down?! We need to check our pulse right now!",
        tone: "anxious",
        audioFile: "audio/voices/voice_paranoid.flac"
    },
    {
        speaker: "Voice of the Skeptic",
        text: "Does anything about this seem right to you? Why does he want us to kill her so badly?",
        tone: "calculating",
        audioFile: "audio/voices/voice_skeptic.flac"
    },
    {
        speaker: "Voice of the Smitten",
        text: "She's breathtaking! Look at the tragic grace in her eyes. We must save her!",
        tone: "romantic",
        audioFile: "audio/voices/voice_smitten.flac"
    },
    {
        speaker: "Voice of the Stubborn",
        text: "Get back up! We aren't dying here. I don't care if she cuts us in half, swing again!",
        tone: "defiant",
        audioFile: "audio/voices/voice_stubborn.flac"
    },
    {
        speaker: "Voice of the Opportunist",
        text: "Now this... this is an opportunity. If we play our cards right, we come out on top.",
        tone: "cunning",
        audioFile: "audio/voices/voice_opportunist.flac"
    },
    {
        speaker: "Voice of the Hunted",
        text: "She's listening to our breathing. Every muscle in her body is coiled to strike. Run.",
        tone: "feral",
        audioFile: "audio/voices/voice_hunted.flac"
    },
    {
        speaker: "Voice of the Cold",
        text: "Dying isn't so bad. It's quiet, at least. Why fight it?",
        tone: "cold",
        audioFile: "audio/voices/voice_cold.flac"
    },
    {
        speaker: "Voice of the Cheated",
        text: "She's cheating! The rules of reality don't even apply to her!",
        tone: "furious",
        audioFile: "audio/voices/voice_cheated.flac"
    },
    {
        speaker: "Voice of the Contrarian",
        text: "What if we just don't? What if we throw the blade out the window?",
        tone: "contrarian",
        audioFile: "audio/voices/voice_contrarian.flac"
    },
    {
        speaker: "Voice of the Broken",
        text: "There's no point in struggling against a god. Just bow.",
        tone: "hopeless",
        audioFile: "audio/voices/voice_broken.flac"
    },
    {
        speaker: "The Princess",
        text: "Hi! Do you think you can get me out of these chains?",
        tone: "curious",
        audioFile: "audio/voices/princess_chains.flac"
    },
    {
        speaker: "The Princess",
        text: "H-hello? Is someone there?",
        tone: "tender",
        audioFile: "audio/voices/princess_hello.flac"
    },
    {
        speaker: "The Witch",
        text: "You turned your back on me. Did you really think I wouldn't bite?",
        tone: "venomous",
        audioFile: "audio/voices/princess_witch.flac"
    },
    {
        speaker: "The Damsel",
        text: "I want whatever you want! As long as we're together, everything is wonderful!",
        tone: "cheerful",
        audioFile: "audio/voices/princess_damsel.flac"
    },
    {
        speaker: "The Nightmare",
        text: "Look at me. Don't close your eyes. If you close your eyes, you won't see what's coming.",
        tone: "horror",
        audioFile: "audio/voices/princess_nightmare.flac"
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
