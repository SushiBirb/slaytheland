import QtQuick
import QtQuick.Shapes
import ".."

// Vector glyph from baked SVG paths. No external icon font or dependency.
// Resolution-independent, styled to antique parchment and pristine blade tints.
Item {
    id: root

    property string name: ""
    property color color: Theme.parchment
    property real stroke: 1.8

    readonly property real u: Math.min(width, height) / 24

    readonly property var glyphs: ({
        "crown": { d: "M3 18h18 M4 18l2-11 5 5 5-5 2 11H4z", fill: false },
        "blade": { d: "M14.5 3.5l6 6-9 9-3-3 9-9z M5.5 18.5l-3 3 M4 14l6 6", fill: false },
        "dagger": { d: "M12 2l2 4-2 11-2-11 2-4z M8 13h8 M12 17v5", fill: false },
        "settings": { d: "M12 15a3 3 0 1 0 0-6 3 3 0 0 0 0 6z M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 1 1-2.83 2.83l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 1 1-4 0v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 1 1-2.83-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 1 1 0-4h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 1 1 2.83-2.83l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 1 1 4 0v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 1 1 2.83 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 1 1 0 4h-.09a1.65 1.65 0 0 0-1.51 1z", fill: false },
        "candle": { d: "M8 21h8 M9 11h6v10H9z M12 3c-1 2-1 4 0 5s1-3 0-5z", fill: false },
        "pencil": { d: "M18 2l4 4-13 13H5v-4L18 2z", fill: false },
        "tree": { d: "M12 3L5 13h4l-3 5h12l-3-5h4z M12 18v4", fill: false },
        "wifi": { d: "M4 9.5C9 4.8 15 4.8 20 9.5 M7 13c3-2.8 7-2.8 10 0 M11 16.8a1.4 1.4 0 1 0 2 0a1.4 1.4 0 1 0-2 0", fill: false },
        "bluetooth": { d: "M12 2.8v18.4 M12 2.8l5.2 4.6-10.4 9 M12 21.2l5.2-4.6-10.4-9", fill: false },
        "mic": { d: "M9 9V6a3 3 0 0 1 6 0v6a3 3 0 0 1-6 0 M5 11a7 7 0 0 0 14 0 M12 18v3", fill: false },
        "mic-off": { d: "M9 9V6a3 3 0 0 1 6 0v3 M15 12v0a3 3 0 0 1-5.6 1.5 M5 11a7 7 0 0 0 11 5.5 M12 19v3 M3 3l18 18", fill: false },
        "speaker": { d: "M4 9v6h4l5 4V5L8 9z M16 9.5a3 3 0 0 1 0 5 M18.5 7.5a6 6 0 0 1 0 9", fill: false },
        "speaker-off": { d: "M4 9v6h4l5 4V5L8 9z M16.2 9.8l4.4 4.4 M20.6 9.8l-4.4 4.4", fill: false },
        "music": { d: "M9 18V5l12-2v13 M9 18a3 3 0 1 1-6 0 3 3 0 0 1 6 0z M21 16a3 3 0 1 1-6 0 3 3 0 0 1 6 0z", fill: false },
        "play": { d: "M7 5l12 7-12 7z", fill: true },
        "pause": { d: "M8 5h3v14H8z M13 5h3v14h-3z", fill: true },
        "prev": { d: "M18 5l-9 7 9 7z M6 5h2v14H6z", fill: true },
        "next": { d: "M6 5l9 7-9 7z M16 5h2v14h-2z", fill: true },
        "moon": { d: "M12 3a6.4 6.4 0 0 0 9 9 9 9 0 1 1-9-9z", fill: false },
        "coffee": { d: "M5 10H14V14.5A3 3 0 0 1 11 17.5H8A3 3 0 0 1 5 14.5Z M14 11C20 11 20 15 14 15 M8.5 8C9.2 7.1 7.8 6.3 8.5 5.3 M11.5 8C12.2 7.1 10.8 6.3 11.5 5.3", fill: false },
        "battery": { d: "M3 8.5h13.4a1.4 1.4 0 0 1 1.4 1.4v4.2a1.4 1.4 0 0 1-1.4 1.4H3a1.4 1.4 0 0 1-1.4-1.4V9.9A1.4 1.4 0 0 1 3 8.5z M20.4 11v2", fill: false },
        "bolt": { d: "M13 2L4 14h6l-1 8 9-12h-6z", fill: true },
        "close": { d: "M6.5 6.5l11 11 M17.5 6.5l-11 11", fill: false },
        "check": { d: "M5 12.8l4.2 4.2L19 7.2", fill: false }
    })

    readonly property var g: glyphs[name] !== undefined ? glyphs[name] : ({ d: "", fill: false })

    Shape {
        width: 24
        height: 24
        scale: root.u
        transformOrigin: Item.TopLeft
        antialiasing: true
        preferredRendererType: Shape.CurveRenderer

        ShapePath {
            strokeColor: root.g.fill ? "transparent" : root.color
            fillColor: root.g.fill ? root.color : "transparent"
            strokeWidth: root.stroke
            capStyle: ShapePath.RoundCap
            joinStyle: ShapePath.RoundJoin
            PathSvg { path: root.g.d }
        }
    }
}
