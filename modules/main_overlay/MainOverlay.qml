pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Effects
import "../sidebar"
import "../../widgets"
import "../../config"

// this supposedly avoids multihead problems
Variants {
    model: Quickshell.screens

    Scope {
        id: scope
        required property var modelData

        Exclusions {
            screen: scope.modelData
            bar: bar
        }

        // fullscreen container
        CustomWindow {
            id: win

            screen: scope.modelData
            name: "main"

            WlrLayershell.exclusionMode: ExclusionMode.Ignore
            // surfaceFormat.opaque: false

            // make a big hole in the middle so we can click things
            mask: Region {
                x: bar.implicitWidth + Config.border.thickness
                y: Config.border.thickness
                width: win.width - bar.implicitWidth - Config.border.thickness * 2
                height: win.height - Config.border.thickness * 2
                intersection: Intersection.Xor
            }

            // take the full screen
            anchors.top: true
            anchors.right: true
            anchors.left: true
            anchors.bottom: true

            // idk if i want it above
            aboveWindows: false

            Item {
                anchors.fill: parent
                layer.enabled: true
                layer.effect: MultiEffect {
                    shadowEnabled: true
                    blurMax: 15
                    shadowColor: "#333"
                }

                Border {
                    bar: bar
                    color: Colors.current.background
                }
            }

            // left bar thing
            Sidebar {
                id: bar
                screen: scope.modelData
            }
        }
    }
}
