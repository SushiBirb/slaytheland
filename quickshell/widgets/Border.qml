import QtQuick
import ".."

Item {
    id: root
    property int borderMargin: 24
    property bool animated: true

    BorderImage {
        id: frameImg
        anchors.fill: parent
        source: Theme.asset("gui/frame.png")
        border.left: root.borderMargin
        border.top: root.borderMargin
        border.right: root.borderMargin
        border.bottom: root.borderMargin
        horizontalTileMode: BorderImage.Stretch
        verticalTileMode: BorderImage.Stretch
        visible: !root.animated
    }

    ShaderEffect {
        id: frameShader
        anchors.fill: parent
        visible: root.animated

        property var source: ShaderEffectSource {
            sourceItem: frameImg
            hideSource: root.animated
            live: true
        }

        property real time: 0.0
        property real intensity: 0.85
        property real vignette: 0.0
        property vector2d resolution: Qt.vector2d(Math.max(root.width, 1.0), Math.max(root.height, 1.0))

        fragmentShader: Qt.resolvedUrl("../shaders/pencil_boil.frag.qsb")

        Timer {
            interval: 83 // 12 fps stepped pencil boil
            running: root.animated && root.visible
            repeat: true
            onTriggered: frameShader.time += 0.083
        }
    }
}
