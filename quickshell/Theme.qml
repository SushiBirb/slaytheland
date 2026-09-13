pragma Singleton
import QtQuick
import Quickshell

Singleton {
    id: root

    // === Color Palette (Slay the Princess Design Tokens) ===
    readonly property color voidBlack: "#0d0b0f"         // Pure shadow, terminal and window backings
    readonly property color charcoal: "#151218"          // Primary panel and dialog surfaces
    readonly property color surfaceAlt: "#1e1922"        // Raised button surfaces, active inputs
    readonly property color surfaceHover: "#28222d"      // Hovered button/choice surfaces
    readonly property color surfaceSelected: "#362e3d"   // Selected choice surfaces
    readonly property color graphiteMuted: "#483f4d"     // Muted borders, inactive workspace glyphs
    readonly property color pencilLight: "#706578"       // Subtext, timestamps, inactive chips
    readonly property color parchment: "#e8ddc5"         // Primary foreground text (antique paper)
    readonly property color parchmentWhite: "#fbf5e6"    // Active headers, hovered text
    readonly property color bloodDried: "#801336"        // Inactive accent border, subtle badges
    readonly property color crimson: "#c72c41"           // Active workspace highlight, blade cursor
    readonly property color crimsonVivid: "#e02438"      // High-priority warnings, urgent alerts
    readonly property color amber: "#d4a373"             // Candlelight warnings, CPU alert threshold

    // === Dynamic Mood Accent Tokens ===
    // Reacts dynamically to the currently manifested Princess vessel
    property color accent: RoomState.moodColor
    Behavior on accent { ColorAnimation { duration: 450; easing.type: Easing.OutCubic } }
    property color accentMuted: RoomState.moodMuted
    Behavior on accentMuted { ColorAnimation { duration: 450; easing.type: Easing.OutCubic } }

    // === Typography Tokens ===
    readonly property string fontTitle: "Kelmscott Roman NF"
    readonly property string fontKelmscott: "Kelmscott Roman NF"
    readonly property string fontBody: "Amatic SC"
    readonly property string fontAmatic: "Amatic SC"
    readonly property string fontHorror: "East Sea Dokdo"

    // === Border & Metric Tokens ===
    readonly property int frameBorder: 24
    readonly property int radiusSmall: 4
    readonly property int radiusMedium: 8
    readonly property int radiusLarge: 14

    // === Asset Path Resolver ===
    // Resolves asset path relative to the slaytheland assets directory
    function asset(relPath) {
        if (!relPath || relPath === "") return "";
        if (relPath.startsWith("file://") || relPath.startsWith("http://") || relPath.startsWith("/")) {
            return relPath.startsWith("/") ? ("file://" + relPath) : relPath;
        }
        return Qt.resolvedUrl("assets/" + relPath);
    }
}
