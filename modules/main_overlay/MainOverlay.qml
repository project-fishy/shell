pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Wayland
import QtQuick
import QtQuick.Effects
import "../sidebar"
import "../../widgets"
import "../../logic"
import "../../config"
import "../sidebar/components/tray"

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

                regions: Helper.flatten([mouseRegions.instances, [bar.menus.mouseRegion]])
            }

            // take the full screen
            anchors.top: true
            anchors.right: true
            anchors.left: true
            anchors.bottom: true

            Panels {
                id: panels
            }

            Item {
                anchors.fill: parent
                layer.enabled: true
                layer.effect: MultiEffect {
                    shadowEnabled: true
                    blurMax: 15
                    shadowColor: Colors.current.background
                }

                Border {
                    bar: bar
                    color: Colors.current.background
                }
            }

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

            // Variants {
            //     id: contextRegions

            //     model: bar.menus.items

            //     Region {
            //         required property var modelData

            //         x: modelData.x
            //         y: modelData.y
            //         width: modelData.width
            //         height: modelData.height

            //         intersection: Intersection.Subtract
            //     }
            // }

            // left bar thing
            Sidebar {
                id: bar
                screen: scope.modelData
            }
        }
    }
}
