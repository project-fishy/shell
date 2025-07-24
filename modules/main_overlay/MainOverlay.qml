pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Wayland
import QtQuick
import QtQuick.Effects
import "../../widgets"
import "../../logic"
import "../../config"

// this holds most of the elements drawn above windows

// this supposedly avoids multihead problems
Variants {
    model: Quickshell.screens

    Scope {
        id: scope
        required property var modelData

        // reserve space
        // Exclusions {
        //     screen: scope.modelData
        //     bar: bar
        // }

        // fullscreen container
        CustomWindow {
            id: win
            name: "main"

            // replicate on every monitor
            screen: scope.modelData

            // we have exclusions at home
            WlrLayershell.exclusionMode: ExclusionMode.Ignore

            // make a big hole in the middle so we can click things
            mask: Region {
                x: 0
                y: 0
                width: win.width
                height: win.height
                intersection: Intersection.Xor

                // reserve clickable space for context menus and panels
                regions: mouseRegions.instances
            }

            // take the full screen
            anchors.top: true
            anchors.right: true
            anchors.left: true
            anchors.bottom: true

            // TODO: make a container that avoids the bar and put
            // context menus and panels in it

            // sliding panels
            Panels {
                id: panels
                screen: scope.modelData
            }

            // generates mouse regions for panels
            Variants {
                id: mouseRegions

                model: panels.children

                Region {
                    required property Item modelData

                    x: modelData.x
                    y: modelData.y
                    width: modelData.width
                    height: modelData.height

                    intersection: Intersection.Subtract
                }
            }
        }
    }
}
