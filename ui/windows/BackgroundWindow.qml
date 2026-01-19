import QtQuick
import Quickshell
import Quickshell.Wayland

import qs.ui.custom

Variants {
    model: Quickshell.screens

    Scope {
        id: scope
        required property ShellScreen modelData

        CustomWindow {
            id: win
            name: "desktop"

            screen: scope.modelData
            aboveWindows: false

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
