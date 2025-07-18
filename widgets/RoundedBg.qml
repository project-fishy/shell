pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import "../config"

// this is supposed to be the background of a SlidingPanel
CustomRect {
    id: root

    required property bool hasBorder // whether to draw the border or not

    color: Colors.current.background

    anchors.fill: parent

    // TODO: we probably want the other sides too right?
    bottomRightRadius: Config.border.radius
    bottomLeftRadius: Config.border.radius

    border {
        color: root.hasBorder ? Colors.current.accent : Colors.current.background
        width: 1 // TODO: move to config
    }

    // TODO: this doesnt work
    Item {
        id: pads
        anchors.fill: parent
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
