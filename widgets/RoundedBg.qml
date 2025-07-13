import QtQuick
import Quickshell

import "../config"

CustomRect {
    id: background

    required property bool hasBorder

    // color: "#0f0"
    color: Colors.current.background
    anchors.fill: parent
    bottomRightRadius: Config.border.radius
    bottomLeftRadius: Config.border.radius

    border {
        color: background.hasBorder ? Colors.current.accent : Colors.current.background
        width: 1
    }

    Item {
        id: pads

        anchors.leftMargin: Config.border.thickness
        anchors.rightMargin: Config.border.thickness
        anchors.topMargin: Config.border.thickness
        anchors.bottomMargin: Config.border.thickness
    }

    Behavior on border.color {
        ColorAnimation {
            duration: Animations.duration.normal
        }
    }
}
