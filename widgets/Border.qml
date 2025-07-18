pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Effects
import "../config"
import "../widgets"

// the round border thing around the screen edges.
Item {
    id: root

    required property Item bar // XXX: why even? take width from config?
    required property string color // XXX: also why?

    anchors.fill: parent

    // rect that fills the whole screen
    CustomRect {
        anchors.fill: parent
        color: root.color

        layer.enabled: true

        // the thing that makes the hole
        layer.effect: MultiEffect {
            maskSource: mask
            maskEnabled: true
            maskInverted: true
            maskThresholdMin: 0.5
            maskSpreadAtMin: 1
        }
    }

    // cutout
    Item {
        id: mask

        visible: false
        anchors.fill: parent

        layer.enabled: true // need this for the hole

        Rectangle {
            anchors.fill: parent
            anchors.margins: Config.border.thickness
            anchors.leftMargin: root.bar.implicitWidth
            radius: Config.border.radius
        }
    }
}
