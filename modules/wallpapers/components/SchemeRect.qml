import QtQuick
import Quickshell

import "../../../widgets"
import "../../../config"

CustomRect {
    id: root
    required property MatugenWrapper.Scheme modelData

    implicitWidth: childrenRect.width + Config.spacing.small * 2
    color: modelData.background
    radius: Config.radius.small

    Row {
        id: layout

        anchors.verticalCenter: parent.verticalCenter
        x: Config.spacing.small
        spacing: Config.spacing.small

        Dot {
            color: root.modelData.primary
        }

        Dot {
            color: root.modelData.secondary
        }

        Dot {
            color: root.modelData.tertiary
        }
    }

    component Dot: CustomRect {
        implicitHeight: 20
        implicitWidth: implicitHeight
        radius: height / 2
    }
}
