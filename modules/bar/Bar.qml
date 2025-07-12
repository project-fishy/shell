import Quickshell
import QtQuick
import "../../logic"
import "../../config"
import "components"

Item {
    id: root
    required property var screen

    anchors.top: parent.top
    anchors.left: parent.left
    anchors.bottom: parent.bottom

    implicitWidth: 30

    Rectangle {
        anchors.fill: parent

        color: Colors.current.background

        Clock {
            anchors.bottom: power.top
        }

        Power {
            id: power
            anchors.bottom: parent.bottom
        }
    }
}
