import QtQuick
import ".."
import "../services"
import "../widgets"

Item {
    id: root

    implicitWidth: 280
    implicitHeight: 210

    Column {
        anchors.fill: parent
        spacing: 8

        Text {
            text: "What will you do?..."
            color: Theme.parchmentWhite
            font.family: Theme.fontTitle
            font.pixelSize: 18
            font.bold: true
        }

        CharcoalButton {
            width: parent.width
            height: 38
            text: "Turn Back  (Lock Screen)"
            isChoice: true
            fontSize: 16
            onClicked: {
                VoiceBus.onLockOpened();
                Session.lock();
            }
        }

        CharcoalButton {
            width: parent.width
            height: 38
            text: "Step Outside  (Log Out)"
            isChoice: true
            fontSize: 16
            onClicked: {
                Session.logout();
            }
        }

        CharcoalButton {
            width: parent.width
            height: 38
            text: "Restart the Loop  (Reboot)"
            isChoice: true
            fontSize: 16
            onClicked: {
                Session.reboot();
            }
        }

        CharcoalButton {
            width: parent.width
            height: 38
            text: "Slay the Princess  (Shutdown)"
            isChoice: true
            fontSize: 16
            activeColor: Theme.crimsonVivid
            onClicked: {
                VoiceBus.onShutdown();
                Session.shutdown();
            }
        }
    }
}
