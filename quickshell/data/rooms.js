// Parallax room manifests for slaytheland
var rooms = [
    {
        id: "woods",
        name: "The Path in the Woods",
        description: "You're on a path in the woods, and at the end of that path is a cabin.",
        hasPrincess: false,
        layers: [
            { name: "Skyline & Trees", path: "backgrounds/ch1/path/bg path p.png", depth: 0.02 },
            { name: "Midground Path", path: "backgrounds/ch1/path/midground path p.png", depth: 0.05 },
            { name: "Foreground Foliage", path: "backgrounds/ch1/path/front path p.png", depth: 0.10 }
        ]
    },
    {
        id: "cabin_exterior",
        name: "The Cabin Exterior",
        description: "The cabin sits quietly among the trees. In its basement is a Princess.",
        hasPrincess: false,
        layers: [
            { name: "Skyline", path: "backgrounds/ch1/cabin exterior/skyline cabin p.png", depth: 0.02 },
            { name: "Flanking Trees", path: "backgrounds/ch1/cabin exterior/bg cabin p.png", depth: 0.03 },
            { name: "Cabin on Hill", path: "backgrounds/ch1/cabin exterior/midground cabin p.png", depth: 0.06 },
            { name: "Foreground Brush", path: "backgrounds/ch1/cabin exterior/foreground cabin p.png", depth: 0.10 }
        ]
    },
    {
        id: "cabin_interior",
        name: "The Cabin Interior",
        description: "The interior of the cabin is clean and sparse. There's a door leading to the basement.",
        hasPrincess: false,
        layers: [
            { name: "Farback Walls", path: "backgrounds/ch1/cabin interior/farback interior cabin p.png", depth: 0.02 },
            { name: "Interior Table", path: "backgrounds/ch1/cabin interior/bg interior cabin p.png", depth: 0.05 },
            { name: "Pristine Blade", path: "backgrounds/ch1/cabin interior/knife interior cabin p.png", depth: 0.05 }
        ]
    },
    {
        id: "basement_stairs",
        name: "The Basement Stairs",
        description: "The stairs creak beneath your feet. Cold air rises from below.",
        hasPrincess: false,
        layers: [
            { name: "Stairs Descent", path: "backgrounds/ch1/basement stairs/bg basement stairs p.png", depth: 0.03 },
            { name: "Basement Doorframe", path: "backgrounds/ch1/basement stairs/front basement stairs p.png", depth: 0.09 }
        ]
    },
    {
        id: "basement",
        name: "The Basement",
        description: "Shadows dance in the dim light. Chains echo against cold stone.",
        hasPrincess: true,
        layers: [
            { name: "Basement Shadow", path: "backgrounds/ch1/basement/farbg flee back p.png", depth: 0.02 },
            { name: "Basement Chamber", path: "backgrounds/ch1/basement/bg basement distant p.png", depth: 0.05 },
            { name: "Iron Shackles", path: "backgrounds/ch1/basement/back basement distant p.png", depth: 0.08 }
        ]
    },
    {
        id: "distant_basement",
        name: "The Distant Basement",
        description: "Shadows dance in the dim light. Chains echo against cold stone.",
        hasPrincess: true,
        layers: [
            { name: "Basement Shadow", path: "backgrounds/ch1/basement/farbg flee back p.png", depth: 0.02 },
            { name: "Basement Chamber", path: "backgrounds/ch1/basement/bg basement distant p.png", depth: 0.05 },
            { name: "Iron Shackles", path: "backgrounds/ch1/basement/back basement distant p.png", depth: 0.08 }
        ]
    },
    {
        id: "mirror",
        name: "The Mirror Room",
        description: "There is a mirror on the wall. You do not want to look into it.",
        hasPrincess: false,
        layers: [
            { name: "The Long Quiet", path: "wallpapers/_ztlq/big/ztlq_1.jpg", depth: 0.02 },
            { name: "Mirror Glass", path: "wallpapers/_ztlq/big/ztlq_2.jpg", depth: 0.06 }
        ]
    }
];

function getRoom(id) {
    for (var i = 0; i < rooms.length; i++) {
        if (rooms[i].id === id) return rooms[i];
    }
    return rooms[0];
}

if (typeof module !== "undefined" && module.exports)
    module.exports = { rooms, getRoom };
