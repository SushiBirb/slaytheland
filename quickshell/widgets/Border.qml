import QtQuick
import ".."

BorderImage {
    id: root
    property int borderMargin: 24
    source: Theme.asset("gui/frame.png")
    border.left: borderMargin
    border.top: borderMargin
    border.right: borderMargin
    border.bottom: borderMargin
    horizontalTileMode: BorderImage.Stretch
    verticalTileMode: BorderImage.Stretch
}
