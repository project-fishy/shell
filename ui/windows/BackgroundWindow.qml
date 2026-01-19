import QtQuick
import Quickshell
import Quickshell.Wayland

import qs.ui.custom
import qs.ui.widgets

Variants {
    model: Quickshell.screens

    Scope {
        id: scope
        required property ShellScreen modelData

        CustomWindow {
            id: win

            screen: scope.modelData
            aboveWindows: false
            name: `desktop-${scope.modelData.name}`

            anchors.top: true
            anchors.bottom: true
            anchors.left: true
            anchors.right: true

            WlrLayershell.exclusionMode: ExclusionMode.Ignore

            CustomRect {
                color: "#333333"
                anchors.fill: parent
            }

            DesktopClock {
                anchors.centerIn: parent
            }
        }
    }
}
