import Quickshell
import Quickshell.Wayland

import QtQuick

import "../../widgets"
import "../../config"

// this is a background window that holds
// the wallpaper and widgets (if any)
Variants {
    model: Quickshell.screens

    Scope {
        id: scope
        required property ShellScreen modelData

        CustomWindow {
            id: root
            aboveWindows: false
            screen: scope.modelData

            // fill the whole screen
            anchors.bottom: true
            anchors.top: true
            anchors.left: true
            anchors.right: true

            // don't reserve space
            WlrLayershell.exclusionMode: ExclusionMode.Ignore

            name: "widgets" // idk

            CachedImage {
                path: root.screen.name == "eDP-1" ? Config.saved.wallpaper : "/home/desant/Pictures/Wallpapers/blue_second_monitor.jpg"
                anchors.fill: parent

                asynchronous: false
            }
        }
    }
}
