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

// this holds most of the elements drawn above windows

// this supposedly avoids multihead problems
Variants {
    model: Quickshell.screens

    Scope {
        id: scope
        required property var modelData

        // reserve space
        Exclusions {
            screen: scope.modelData
            bar: bar
        }

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
                x: bar.implicitWidth + Config.border.thickness
                y: Config.border.thickness
                width: win.width - bar.implicitWidth - Config.border.thickness * 2
                height: win.height - Config.border.thickness * 2
                intersection: Intersection.Xor

                // reserve clickable space for context menus and panels
                regions: Helper.flatten([mouseRegions.instances, [bar.menus.mouseRegion]])
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
            }

            // border container
            Item {
                anchors.fill: parent

                // border shadows
                // it does look better with them
                layer.enabled: true
                layer.effect: MultiEffect {
                    shadowEnabled: true
                    blurMax: 15
                    shadowColor: Colors.current.background
                }

                // border
                // Border {
                //     bar: bar                            // XXX: remove bar?
                //     color: Colors.current.background    // XXX: and this?
                // }
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

            // new dashboard
            TripleToast {
                anchors.right: parent.right
                anchors.top: parent.top

                collapseTo: Config.toast.top
                secondAnchor: Config.toast.right

                compactConponent: Item {
                    implicitHeight: Config.toast.size
                    implicitWidth: 200

                    CustomText {
                        text: Time.format("hh:mm")
                        anchors.centerIn: parent
                        horizontalAlignment: Text.AlignHCenter
                    }
                }

                fullComponent: Rectangle {
                    implicitHeight: 400
                    implicitWidth: 400
                    color: Colors.current.error
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
