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

    implicitWidth: Math.min(800, parent ? parent.width - 60 : 700)
    implicitHeight: 180

    // Synchronize with VoiceBus
    Connections {
        target: VoiceBus
        function onDialogueTriggered(spk, txt) {
            root.startTypewriter(spk, txt);
        }
    }

    function startTypewriter(spk, txt) {
        root.speaker = spk;
        root.fullText = txt;
        root.displayedText = "";
        root.charIndex = 0;
        root.isTyping = true;
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
        VoiceBus.isTalking = false;
        root.opacity = 0.0;
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

    opacity: root.fullText !== "" ? 1.0 : 0.0
    Behavior on opacity { NumberAnimation { duration: 250 } }

    // Textbox Background Container
    Item {
        anchors.fill: parent

        // Main 9-slice Frame
        Border {
            anchors.fill: parent
            borderMargin: 24
        }

        // Speaker Namebox (Top-Left)
        Item {
            id: nameboxContainer
            x: 32
            y: -18
            width: Math.max(140, nameText.implicitWidth + 36)
            height: 36
            visible: root.speaker !== ""

            Border {
                anchors.fill: parent
                borderMargin: 12
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

        // Dialogue Body Text
        Item {
            anchors.fill: parent
            anchors.margins: 28
            anchors.topMargin: 24

            Text {
                id: bodyText
                anchors.fill: parent
                text: root.displayedText
                color: Theme.parchmentWhite
                font.family: Theme.fontBody
                font.pixelSize: 26
                wrapMode: Text.Wrap
                lineHeight: 1.1
            }

            // Blinking Blade / Continue Glyph
            Text {
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.margins: 4
                text: "🗡️"
                font.pixelSize: 18
                visible: !root.isTyping

                SequentialAnimation on opacity {
                    loops: Animation.Infinite
                    NumberAnimation { from: 0.2; to: 1.0; duration: 600 }
                    NumberAnimation { from: 1.0; to: 0.2; duration: 600 }
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: root.skipTypewriter()
        }
    }
}
