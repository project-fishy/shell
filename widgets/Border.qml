pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Effects
import "../config"
import "../widgets"

Item {
    id: root

    required property Item bar
    required property string color

    anchors.fill: parent

    CustomRect {
        anchors.fill: parent
        color: root.color

        layer.enabled: true
        layer.effect: MultiEffect {
            maskSource: mask
            maskEnabled: true
            maskInverted: true
            maskThresholdMin: 0.5
            maskSpreadAtMin: 1
        }
    }

    Item {
        id: mask

        anchors.fill: parent
        layer.enabled: true
        visible: false

        Rectangle {
            anchors.fill: parent
            anchors.margins: Config.border.thickness
            anchors.leftMargin: root.bar.implicitWidth // + Config.border.thickness
            radius: Config.border.radius
        }
    }
}
