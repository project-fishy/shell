pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Widgets
import Quickshell.Io

import "../../widgets"
import "../../logic"
import "../../config"
import "components"

Item {
    id: root

    MatugenWrapper {
        id: schemesGen

        path: Config.saved.wallpaper

        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left

        implicitWidth: childrenRect.width

        Column {
            id: layout

            Repeater {
                model: ScriptModel {
                    values: [...schemesGen.schemes]
                }

                SchemeRect {
                    implicitHeight: schemesGen.height / schemesGen.schemes.length

                    TapHandler {
                        onTapped: {
                            Config.saved.scheme = parent.modelData.scheme;
                        }
                    }
                }
            }
        }

        Selector {
            target: layout.children.find(c => {
                return c instanceof SchemeRect && c.modelData.scheme == Config.saved.scheme;
            })
        }
    }

    ClippingRectangle {
        id: wallpapers

        property var paths

        anchors.left: schemesGen.right
        anchors.leftMargin: Config.spacing.small
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        color: "transparent"

        Flickable {
            id: flickable

            anchors.fill: parent
            flickableDirection: Flickable.HorizontalFlick
            contentHeight: grid.height
            contentWidth: grid.width
            flickDeceleration: 4000

            Grid {
                id: grid

                rows: 3

                Repeater {
                    model: wallpapers.paths

                    CachedImage {
                        required property string modelData
                        path: modelData

                        height: wallpapers.height / grid.rows
                        width: height / 9 * 16

                        TapHandler {
                            onTapped: {
                                let pos = parent.mapToItem(flickable, point.position);
                                if (pos.y >= 0 && pos.y < flickable.height && pos.x >= 0 && pos.x < flickable.width)
                                    Config.saved.wallpaper = parent.modelData;
                            }
                        }
                    }
                }
            }

            // TODO: add animation on contentX

            Selector {
                target: grid.children.find(c => {
                    return c instanceof CachedImage && c.path == Config.saved.wallpaper;
                })
            }
        }

        // TODO: scrolling
        // Connections {
        //     target: root.mous
        //
        //     function onWheel(event) {
        //         // flickable.contentX -= event.angleDelta.y;
        //         flickable.flick(event.angleDelta.y * 15, 0);
        //     }
        // }

        Process {
            id: scraper

            running: true
            command: ["sh", "-c", "ls /home/desant/Pictures/Wallpapers"]
            stdout: StdioCollector {
                onStreamFinished: wallpapers.paths = this.text.split("\n").filter(p => p != "").map(p => "/home/desant/Pictures/Wallpapers/" + p)
            }
        }
    }

    component Selector: CustomRect {
        required property Item target

        x: target?.x
        y: target?.y
        width: target?.width
        height: target?.height
        color: Colors.current.primary
        radius: Config.radius.small

        layer.enabled: true
        layer.effect: MultiEffect {
            maskSource: mask
            maskEnabled: true
            maskInverted: true
            maskThresholdMin: 0.5
            maskSpreadAtMin: 1
        }

        // cutout
        Item {
            id: mask

            visible: false
            anchors.fill: parent

            layer.enabled: true // need this for the hole

            Rectangle {
                anchors.fill: parent
                anchors.margins: Config.spacing.smaller
                radius: Config.radius.small
            }
        }
    }
}
