import QtQuick
import Quickshell

import "../../widgets"
import "components"

MatugenWrapper {
    id: root

    path: "/home/desant/Downloads/image.png"

    anchors.top: parent.top
    anchors.bottom: parent.bottom
    anchors.left: parent.left

    CustomRect {
        anchors.fill: parent
        color: "#0f0"
    }

    implicitWidth: childrenRect.width

    Column {
        Repeater {
            model: root.schemes
            SchemeRect {
                implicitHeight: root.height / root.schemes.length
                // implicitHeight: 59
            }
        }
    }
}
