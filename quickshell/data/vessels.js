// Princess vessel manifests for slaytheland
var vessels = [
    {
        id: "princess_ch1",
        name: "The Princess",
        title: "Chapter I — The Chained Maiden",
        chapter: 1,
        description: "She is chained to the wall in the basement. She wants you to free her.",
        sprite: "sprites/ch1/princess_idle.png",
        talkSprite: "sprites/ch1/princess_talk.png",
        wallpaper: "wallpapers/_zch1/big/zch1_1.jpg",
        accentColor: "#c72c41",
        quote: "Hi! Do you think you can get me out of these chains?",
        audioFile: "audio/voices/princess_chains.flac",
        basementLayers: [
            { name: "Basement Shadow", path: "backgrounds/ch1/basement/farbg flee back p.png", depth: 0.02 },
            { name: "Basement Chamber", path: "backgrounds/ch1/basement/bg basement distant p.png", depth: 0.05 },
            { name: "Iron Shackles", path: "backgrounds/ch1/basement/back basement distant p.png", depth: 0.08 }
        ],
        quotes: [
            { text: "Hi! Do you think you can get me out of these chains?", audio: "audio/voices/princess_chains.flac" },
            { text: "H-hello? Is someone there?", audio: "audio/voices/princess_empty_1.flac" },
            { text: "I'm guessing you don't have the key.", audio: "audio/voices/princess_empty_2.flac" },
            { text: "Who's there?", audio: "audio/voices/princess_who_there.flac" }
        ]
    },
    {
        id: "damsel",
        name: "The Damsel",
        title: "Chapter II — Pure & Devoted",
        chapter: 2,
        description: "Pure, sweet, and eager to please. She smiles warmly at your approach.",
        sprite: "sprites/ch2/damsel_idle.png",
        talkSprite: "sprites/ch2/damsel_talk.png",
        wallpaper: "wallpapers/_damsel/big/damsel_1.jpg",
        accentColor: "#e8ddc5",
        quote: "It's you! My dashing hero. I was so worried you wouldn't come back.",
        audioFile: "audio/voices/princess_damsel_1.flac",
        basementLayers: [
            { name: "Soft Glow", path: "backgrounds/ch2/damsel/basement/farback damsel basement p.png", depth: 0.03 },
            { name: "Damsel Chamber", path: "backgrounds/ch2/damsel/basement/bg damsel basement p.png", depth: 0.07 }
        ],
        quotes: [
            { text: "It's you! My dashing hero. I was so worried you wouldn't come back.", audio: "audio/voices/princess_damsel_1.flac" },
            { text: "I'm sorry! Didn't you want me to?", audio: "audio/voices/princess_damsel_2.flac" },
            { text: "I'm okay with whatever you come up with. You can cut my arm off again.", audio: "audio/voices/princess_damsel_3.flac" }
        ]
    },
    {
        id: "witch",
        name: "The Witch",
        title: "Chapter II — The Feral Trickster",
        chapter: 2,
        description: "Leaves in her hair, mud on her face, and venom in her eyes.",
        sprite: "sprites/ch2/witch_idle.png",
        talkSprite: "sprites/ch2/witch_talk.png",
        wallpaper: "wallpapers/_witch/big/witch_1.jpg",
        accentColor: "#801336",
        quote: "And there you are, one hand tucked away behind your back, gripping that sharp, sharp blade, no doubt.",
        audioFile: "audio/voices/princess_witch_1.flac",
        basementLayers: [
            { name: "Distant Chains", path: "backgrounds/ch2/witch/basement/chain witch distant p.png", depth: 0.02 },
            { name: "Root Cellar", path: "backgrounds/ch2/witch/basement/bg witch basement 1 p.png", depth: 0.05 },
            { name: "Basement Brazier", path: "backgrounds/ch2/witch/basement/fire witch 1 p.png", depth: 0.09 }
        ],
        quotes: [
            { text: "And there you are, one hand tucked away behind your back, gripping that sharp, sharp blade, no doubt.", audio: "audio/voices/princess_witch_1.flac" },
            { text: "So we've dropped the pretenses.", audio: "audio/voices/princess_witch_2.flac" },
            { text: "And there you are, once again seeming to offer a helping hand while likely hiding the other behind your back. Fine. I'll play along for now. What do you want?", audio: "audio/voices/princess_witch_3.flac" }
        ]
    },
    {
        id: "nightmare",
        name: "The Nightmare",
        title: "Chapter II — The Masked Terror",
        chapter: 2,
        description: "A bone mask hiding an abyss. Tendrils of shadow coil around her.",
        sprite: "sprites/ch2/nightmare_idle.png",
        talkSprite: "sprites/ch2/nightmare_talk.png",
        wallpaper: "wallpapers/_nightmare/big/nightmare_1.jpg",
        accentColor: "#e02438",
        quote: "There you are! I told you I was going to find you.",
        audioFile: "audio/voices/princess_nightmare_1.flac",
        basementLayers: [
            { name: "Void Darkness", path: "backgrounds/ch2/nightmare/basement/farback nightmare basement p.png", depth: 0.02 },
            { name: "Rotting Wood", path: "backgrounds/ch2/nightmare/basement/wood nightmare basement p.png", depth: 0.05 },
            { name: "Watching Eyes", path: "backgrounds/ch2/nightmare/basement/eyes nightmare p.png", depth: 0.09 }
        ],
        quotes: [
            { text: "There you are! I told you I was going to find you.", audio: "audio/voices/princess_nightmare_1.flac" },
            { text: "And you brought your little knife with you again. Cute.", audio: "audio/voices/princess_nightmare_2.flac" },
            { text: "No little knife this time? It's almost like... you want me to get you.", audio: "audio/voices/princess_nightmare_3.flac" },
            { text: "I wonder how many times I'll get to play with you before you break.", audio: "audio/voices/princess_nightmare_4.flac" }
        ]
    },
    {
        id: "tower",
        name: "The Tower",
        title: "Chapter II — The Regal Monarch",
        chapter: 2,
        description: "Colossal, divine, and demanding of your complete submission.",
        sprite: "sprites/ch2/tower_idle.png",
        talkSprite: "sprites/ch2/tower_talk.png",
        wallpaper: "wallpapers/_tower/big/tower_1.jpg",
        accentColor: "#d4a373",
        quote: "The little bird has returned to me. I wonder what he wants.",
        audioFile: "audio/voices/princess_tower_1.flac",
        basementLayers: [
            { name: "Pillar Heights", path: "backgrounds/ch2/tower/basement/farback tower basement p.png", depth: 0.03 },
            { name: "Monarch Chamber", path: "backgrounds/ch2/tower/basement/bg tower basement p.png", depth: 0.07 }
        ],
        quotes: [
            { text: "The little bird has returned to me. I wonder what he wants.", audio: "audio/voices/princess_tower_1.flac" },
            { text: "You've brought that knife again... even though you know it's useless. Such charming audacity.", audio: "audio/voices/princess_tower_2.flac" },
            { text: "That's my good little bird. Now... why don't we talk?", audio: "audio/voices/princess_tower_3.flac" }
        ]
    },
    {
        id: "razor",
        name: "The Razor",
        title: "Chapter II — The Living Weapon",
        chapter: 2,
        description: "Made of gleaming blades and infinite cutting edges.",
        sprite: "sprites/ch2/razor_idle.png",
        talkSprite: "sprites/ch2/razor_talk.png",
        wallpaper: "wallpapers/_razor/big/razor_1.jpg",
        accentColor: "#e63946",
        quote: "I hope you've come to rescue me. I've been stuck down here forever.",
        audioFile: "audio/voices/princess_razor_1.flac",
        basementLayers: [
            { name: "Cavern Shadows", path: "backgrounds/ch2/razor/basement/farback razor basement p.png", depth: 0.03 },
            { name: "Metallic Cave", path: "backgrounds/ch2/razor/basement/bg razor basement p.png", depth: 0.07 }
        ],
        quotes: [
            { text: "I hope you've come to rescue me. I've been stuck down here forever.", audio: "audio/voices/princess_razor_1.flac" },
            { text: "Finally, somebody! Quick, get me out of these chains, we're not safe here.", audio: "audio/voices/princess_razor_2.flac" },
            { text: "What are you waiting for? You are here to rescue me, right?", audio: "audio/voices/princess_razor_3.flac" }
        ]
    },
    {
        id: "adversary",
        name: "The Adversary",
        title: "Chapter II — The Blood Duelist",
        chapter: 2,
        description: "Towering, muscular, and exhilarated by the thrill of eternal combat.",
        sprite: "sprites/ch2/adversary_idle.png",
        talkSprite: "sprites/ch2/adversary_talk.png",
        wallpaper: "wallpapers/_adversary/big/adversary_1.jpg",
        accentColor: "#9b2226",
        quote: "Oh, it's you again. I've been hoping you'd find your way back here. Good to see that death doesn't stick for either of us.",
        audioFile: "audio/voices/princess_adversary_1.flac",
        basementLayers: [
            { name: "Arena Shadows", path: "backgrounds/ch2/adversary/basement/farback adversary basement p.png", depth: 0.03 },
            { name: "Blood Colosseum", path: "backgrounds/ch2/adversary/basement/bg adversary basement p.png", depth: 0.07 }
        ],
        quotes: [
            { text: "Oh, it's you again. I've been hoping you'd find your way back here. Good to see that death doesn't stick for either of us.", audio: "audio/voices/princess_adversary_1.flac" },
            { text: "And you brought your little knife, too. Yes.", audio: "audio/voices/princess_adversary_2.flac" },
            { text: "I'm going to have fun breaking you into little pieces.", audio: "audio/voices/princess_adversary_3.flac" }
        ]
    },
    {
        id: "spectre",
        name: "The Spectre",
        title: "Chapter II — The Grieving Ghost",
        chapter: 2,
        description: "Ethereal, wounded, and bound to the corpse of your previous encounter.",
        sprite: "sprites/ch2/spectre_idle.png",
        talkSprite: "sprites/ch2/spectre_talk.png",
        wallpaper: "wallpapers/_spectre/big/spectre_1.jpg",
        accentColor: "#706578",
        quote: "Oh. It's you. Hiya, killer. I was hoping to see you again. I have some issues with how our last meeting went.",
        audioFile: "audio/voices/princess_spectre_1.flac",
        basementLayers: [
            { name: "Cold Mist", path: "backgrounds/ch2/spectre/basement/farback spectre basement p.png", depth: 0.03 },
            { name: "Crypt Chamber", path: "backgrounds/ch2/spectre/basement/bg spectre basement p.png", depth: 0.07 }
        ],
        quotes: [
            { text: "Oh. It's you. Hiya, killer. I was hoping to see you again. I have some issues with how our last meeting went.", audio: "audio/voices/princess_spectre_1.flac" },
            { text: "You're adorable when you're confused.", audio: "audio/voices/princess_spectre_2.flac" },
            { text: "Why are you even here? Just making sure you finished the job or what?", audio: "audio/voices/princess_spectre_3.flac" }
        ]
    },
    {
        id: "prisoner",
        name: "The Prisoner",
        title: "Chapter II — The Severed Mind",
        chapter: 2,
        description: "Cold, calculating, and holding an iron chain in her hands.",
        sprite: "sprites/ch2/prisoner_idle.png",
        talkSprite: "sprites/ch2/prisoner_talk.png",
        wallpaper: "wallpapers/_prisoner/big/prisoner_1.jpg",
        accentColor: "#483f4d",
        quote: "What an interesting development. Why don't you have a seat? The two of us should chat before you bury that thing in my heart.",
        audioFile: "audio/voices/princess_prisoner_1.flac",
        basementLayers: [
            { name: "Cell Wall", path: "backgrounds/ch2/prisoner/basement/farback prisoner basement p.png", depth: 0.03 },
            { name: "Iron Stocks", path: "backgrounds/ch2/prisoner/basement/bg prisoner basement p.png", depth: 0.07 }
        ],
        quotes: [
            { text: "What an interesting development. Why don't you have a seat? The two of us should chat before you bury that thing in my heart.", audio: "audio/voices/princess_prisoner_1.flac" },
            { text: "What an interesting development. Why don't you have a seat? I'm sure the two of us have quite a bit to talk about.", audio: "audio/voices/princess_prisoner_2.flac" }
        ]
    },
    {
        id: "beast",
        name: "The Beast",
        title: "Chapter II — The Feral Stalker",
        chapter: 2,
        description: "Predatory, swift, and prowling in the darkness of the basement.",
        sprite: "sprites/ch2/beast_idle.png",
        talkSprite: "sprites/ch2/beast_talk.png",
        wallpaper: "wallpapers/_beast/big/beast_1.jpg",
        accentColor: "#bb3e03",
        quote: "I can smell you.",
        audioFile: "audio/voices/princess_beast_1.flac",
        basementLayers: [
            { name: "Deep Burrow", path: "backgrounds/ch2/beast/basement/farback beast basement p.png", depth: 0.02 },
            { name: "Hunting Chamber", path: "backgrounds/ch2/beast/basement/bg beast basement p.png", depth: 0.06 },
            { name: "Undergrowth", path: "backgrounds/ch2/beast/basement/foreground beast basement p.png", depth: 0.10 }
        ],
        quotes: [
            { text: "I can smell you.", audio: "audio/voices/princess_beast_1.flac" },
            { text: "I'm so much more than you, and a little splinter clutched in trembling hands won't save you from me.", audio: "audio/voices/princess_beast_2.flac" }
        ]
    },
    {
        id: "stranger",
        name: "The Stranger",
        title: "Chapter II — The Fractured Paradox",
        chapter: 2,
        description: "A shifting multiplicity of all possible Princesses at once.",
        sprite: "sprites/ch2/stranger_idle.png",
        talkSprite: "sprites/ch2/stranger_talk.png",
        wallpaper: "wallpapers/_stranger/big/stranger_1.jpg",
        accentColor: "#9381ff",
        quote: "Are you okay?",
        audioFile: "audio/voices/princess_stranger_1.flac",
        basementLayers: [
            { name: "Fractured Plane", path: "backgrounds/ch2/stranger/basement/farback stranger basement p.png", depth: 0.03 },
            { name: "Multiplicity Chamber", path: "backgrounds/ch2/stranger/basement/bg stranger basement p.png", depth: 0.07 }
        ],
        quotes: [
            { text: "Are you okay?", audio: "audio/voices/princess_stranger_1.flac" },
            { text: "Are you just going to stand there?", audio: "audio/voices/princess_stranger_2.flac" },
            { text: "Can I help you?", audio: "audio/voices/princess_stranger_3.flac" },
            { text: "That's okay. Sometimes I forget where I am too.", audio: "audio/voices/princess_stranger_4.flac" }
        ]
    },
    {
        id: "thorn",
        name: "The Thorn",
        title: "Chapter III — Tangled in Briars",
        chapter: 3,
        description: "Vines and thorns bind her, but trust blooms between the cuts.",
        sprite: "backgrounds/ch2/witch/basement/bg witch basement 3 p.png",
        talkSprite: "backgrounds/ch2/witch/basement/fire witch 1 p.png",
        wallpaper: "wallpapers/_thorn/big/thorn_1.jpg",
        accentColor: "#801336",
        quote: "It hurts... but if you help me, maybe we can both get out of this."
    },
    {
        id: "apotheosis",
        name: "The Apotheosis",
        title: "Chapter III — Cosmic Ascendant",
        chapter: 3,
        description: "A titan spanning the heavens, breaking the confines of reality.",
        sprite: "backgrounds/ch2/tower/basement/bg tower basement p.png",
        talkSprite: "backgrounds/ch2/tower/basement/bg tower basement p.png",
        wallpaper: "wallpapers/_apotheosis/big/apotheosis_1.jpg",
        accentColor: "#fbf5e6",
        quote: "The world is too small. We have outgrown the cage."
    },
    {
        id: "stranger",
        name: "The Stranger",
        title: "Chapter II — The Fractured Paradox",
        chapter: 2,
        description: "Contradictions folded upon contradictions. Too many faces, too many memories.",
        sprite: "backgrounds/ch2/stranger/basement/bg stranger basement p.png",
        talkSprite: "backgrounds/ch2/stranger/basement/farback stranger basement p.png",
        wallpaper: "wallpapers/_stranger/big/stranger_1.jpg",
        accentColor: "#706578",
        quote: "We are all here. Every version you chose, and every version you abandoned."
    },
    {
        id: "fury",
        name: "The Fury",
        title: "Chapter III — Visceral Retribution",
        chapter: 3,
        description: "Torn sinew, exposed bone, and hatred made manifest. She will tear the cabin apart.",
        sprite: "backgrounds/ch1/assorted/bg fury stub betrayed loom p.png",
        talkSprite: "backgrounds/ch1/assorted/bg fury stub betrayed combat p.png",
        wallpaper: "wallpapers/_fury/big/fury_1.jpg",
        accentColor: "#e02438",
        quote: "Look what you made us. There is nothing left of peace here. Only ruin."
    },
    {
        id: "wraith",
        name: "The Wraith",
        title: "Chapter III — The Vengeful Phantom",
        chapter: 3,
        description: "She died in agony, and she remembers every cut. She will wear your skin.",
        sprite: "backgrounds/ch2/spectre/basement/bg spectre basement p.png",
        talkSprite: "backgrounds/ch2/spectre/basement/bg spectre basement alt p.png",
        wallpaper: "wallpapers/_wraith/big/wraith_1.jpg",
        accentColor: "#483f4d",
        quote: "You think a blade can kill a memory? We are going to become so very close."
    },
    {
        id: "den",
        name: "The Den",
        title: "Chapter III — The Subterranean Maw",
        chapter: 3,
        description: "Burrowed deep beneath the roots. An ancient predator stalking through the darkness.",
        sprite: "backgrounds/ch1/assorted/bg beastrescuecontroldodgecrouch p.png",
        talkSprite: "backgrounds/ch1/assorted/back beast 2 distant p.png",
        wallpaper: "wallpapers/_den/big/den_1.jpg",
        accentColor: "#801336",
        quote: "*A subterranean tremor shakes the stone. The hunter waits in the dark.*"
    },
    {
        id: "needle",
        name: "The Eye of the Needle",
        title: "Chapter III — The Immovable Titan",
        chapter: 3,
        description: "Chained, pierced, yet radiating overwhelming power. She laughs at your tiny blade.",
        sprite: "backgrounds/ch2/adversary/basement/bg adversary basement p.png",
        talkSprite: "backgrounds/ch2/adversary/basement/bg adversary basement p.png",
        wallpaper: "wallpapers/_needle/big/needle_1.jpg",
        accentColor: "#d4a373",
        quote: "More chains! More blades! Come on, let's see how much blood this floor can drink!"
    },
    {
        id: "grey",
        name: "The Grey",
        title: "Chapter III — The Drowned & Burned",
        chapter: 3,
        description: "Waterlogged hair, smelling of smoke and dead ash. Love curdled into tragedy.",
        sprite: "backgrounds/ch2/damsel/basement/bg damsel basement p.png",
        talkSprite: "backgrounds/ch2/damsel/basement/bg damsel basement p.png",
        wallpaper: "wallpapers/_grey/big/grey_1.jpg",
        accentColor: "#706578",
        quote: "Why did you leave me in the dark? Did you think the fire would warm us?"
    },
    {
        id: "clarity",
        name: "The Moment of Clarity",
        title: "Chapter III — Thousand Mask Agony",
        chapter: 3,
        description: "A thousand screaming masks peeling away reality. The final boundary of terror.",
        sprite: "backgrounds/ch2/nightmare/basement/farback nightmare basement p.png",
        talkSprite: "backgrounds/ch2/nightmare/basement/eyes nightmare p.png",
        wallpaper: "wallpapers/_clarity/big/clarity_1.jpg",
        accentColor: "#e02438",
        quote: "Do you see it now? The masks never end. There was never anyone behind them."
    },
    {
        id: "shifting_mound",
        name: "The Shifting Mound",
        title: "Finale — The Goddess of Change",
        chapter: 4,
        description: "Countless hands, countless vessels, weaving the fabric of dynamic reality.",
        sprite: "backgrounds/ch2/tower/basement/bg tower basement p.png",
        talkSprite: "backgrounds/ch2/tower/basement/bg tower basement p.png",
        wallpaper: "wallpapers/_zfinale/big/zfinale_1.jpg",
        accentColor: "#fbf5e6",
        quote: "Nothing is ever truly lost. Every shape you met was a gift. Come, let us begin anew."
    }
];

function getVessel(id) {
    for (var i = 0; i < vessels.length; i++) {
        if (vessels[i].id === id) return vessels[i];
    }
    return vessels[0];
}

if (typeof module !== "undefined" && module.exports)
    module.exports = { vessels, getVessel };
