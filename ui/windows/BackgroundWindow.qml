import QtQuick
import Quickshell
import Quickshell.Wayland

import qs.ui.custom
import qs.ui.widgets
import qs.config

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

            CachedImage {
                anchors.fill: parent
                // TODO: load from config
                path: "/home/desant/Pictures/Wallpapers/102808319_p0.png"
            }

            DesktopClock {
                anchors.centerIn: parent
            }
        }
    }
}
