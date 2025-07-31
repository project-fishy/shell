import QtQuick
import Quickshell

import "../../../widgets"
import "../../../config"

CustomRect {
    id: scheme_rect
    required property MatugenWrapper.Scheme modelData

    // implicitHeight: 50
    implicitWidth: childrenRect.width + Config.spacing.small * 2
    color: modelData.background
    radius: Config.radius.small

    Row {
        anchors.verticalCenter: parent.verticalCenter
        x: Config.spacing.small
        // implicitHeight: parent.height = Config.spacing.smaller * 2

        Dot {
            color: scheme_rect.modelData.primary
            implicitHeight: scheme_rect.height - Config.spacing.small * 2
        }

        Dot {
            color: scheme_rect.modelData.secondary
        }
    }

    component Dot: CustomRect {
        // implicitHeight: parent.height - Config.spacing.small * 2
        implicitWidth: implicitHeight
        radius: height / 2
    }
}
