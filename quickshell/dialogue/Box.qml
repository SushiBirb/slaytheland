import QtQuick
import ".."
import "../widgets"

Item {
    id: root

    property string speaker: VoiceBus.currentSpeaker
    property string fullText: VoiceBus.currentText
    property string displayedText: ""
    property int charIndex: 0
    property bool isTyping: false

    implicitWidth: Math.min(840, parent ? parent.width : 840)
    implicitHeight: 220
    anchors.fill: parent

    // Synchronize with VoiceBus
    Connections {
        target: VoiceBus
        function onDialogueTriggered(spk, txt) {
            root.startTypewriter(spk, txt);
        }
    }

    property bool active: false

    function startTypewriter(spk, txt) {
        root.speaker = spk;
        root.fullText = txt;
        root.displayedText = "";
        root.charIndex = 0;
        root.isTyping = true;
        root.active = true;
        autoDismissTimer.stop();
        typeTimer.restart();
    }

    function skipTypewriter() {
        if (root.isTyping) {
            typeTimer.stop();
            root.displayedText = root.fullText;
            root.isTyping = false;
            VoiceBus.isTalking = false;
            autoDismissTimer.restart();
        } else {
            root.dismiss();
        }
    }

    function dismiss() {
        typeTimer.stop();
        autoDismissTimer.stop();
        root.isTyping = false;
        root.active = false;
        VoiceBus.isTalking = false;
        VoiceBus.currentText = "";
    }

    // 20 chars/sec typewriter timer = 50ms per character
    Timer {
        id: typeTimer
        interval: 50
        repeat: true
        running: false
        onTriggered: {
            if (root.charIndex < root.fullText.length) {
                root.charIndex++;
                root.displayedText = root.fullText.substring(0, root.charIndex);
            } else {
                typeTimer.stop();
                root.isTyping = false;
                VoiceBus.isTalking = false;
                autoDismissTimer.restart();
            }
        }
    }

    // Auto-dismiss after 8 seconds of idle
    Timer {
        id: autoDismissTimer
        interval: 8000
        onTriggered: root.dismiss()
    }

    opacity: root.active ? 1.0 : 0.0
    visible: opacity > 0.0
    Behavior on opacity { NumberAnimation { duration: 250 } }

    // Textbox Background Container (Framed and centered for authentic visual novel framing)
    Item {
        id: textboxContainer
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 36
        width: Math.min(940, parent.width - 48)
        height: 170

        // Authentic dark backing + vignette
        Rectangle {
            anchors.fill: parent
            radius: 4
            color: Qt.rgba(0.06, 0.05, 0.08, 0.88)
            border.color: Theme.graphiteMuted
            border.width: 1
        }

        Image {
            anchors.fill: parent
            source: Theme.asset("gui/textbox.png")
            fillMode: Image.Stretch
            opacity: 0.95
        }

        // Dialogue Body Text
        Item {
            anchors.fill: parent
            anchors.margins: 28
            anchors.topMargin: 20

            Text {
                id: bodyText
                anchors.fill: parent
                text: root.displayedText
                color: Theme.parchmentWhite
                font.family: Theme.fontBody
                font.pixelSize: 26
                wrapMode: Text.Wrap
                lineHeight: 1.15
            }

            // Blinking Blade / Continue Glyph
            Image {
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.margins: 4
                width: 22
                height: 22
                source: Theme.asset("gui/ctc_hero.png")
                visible: !root.isTyping
                fillMode: Image.PreserveAspectFit

                SequentialAnimation on opacity {
                    loops: Animation.Infinite
                    NumberAnimation { from: 0.3; to: 1.0; duration: 500 }
                    NumberAnimation { from: 1.0; to: 0.3; duration: 500 }
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: root.skipTypewriter()
        }
    }

    // Speaker Namebox (Sits above textboxContainer, unclipped)
    Item {
        id: nameboxContainer
        anchors.left: textboxContainer.left
        anchors.leftMargin: 24
        anchors.bottom: textboxContainer.top
        anchors.bottomMargin: -6
        width: Math.max(160, nameText.implicitWidth + 40)
        height: 38
        visible: root.speaker !== ""

        Rectangle {
            anchors.fill: parent
            radius: 3
            color: Theme.voidBlack
            border.color: Theme.crimson
            border.width: 1
        }

        Image {
            anchors.fill: parent
            source: Theme.asset("gui/namebox.png")
            fillMode: Image.Stretch
            opacity: 0.9
        }

        Text {
            id: nameText
            anchors.centerIn: parent
            text: root.speaker
            color: Theme.crimson
            font.family: Theme.fontTitle
            font.pixelSize: 18
            font.bold: true
        }
    }
}
