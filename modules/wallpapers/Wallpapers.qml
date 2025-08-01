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

    required property MouseArea mous

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
                    // implicitHeight: 59
                    Component.onCompleted: {
                        print("created rect for " + modelData.pic);
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
                    }
                }
            }

            Selector {
                target: grid.children.find(c => {
                    // print(c.path);
                    return c instanceof CachedImage && c.path == Config.saved.wallpaper;
                })
            }
        }

        Connections {
            target: root.mous

            function onPressed(event: MouseEvent) {
                // within schemes
                // TODO: offset
                let scheme = layout.children.find(c => c instanceof SchemeRect && Helper.checkInBounds(c, event, 0, 0));

                if (scheme) {
                    Config.saved.scheme = scheme.modelData.scheme;
                    event.accepted = true;
                    return;
                }

                //within wallpaper
                let offsetX = wallpapers.x - flickable.contentX;
                let wallpaper = grid.children.find(c => c instanceof CachedImage && Helper.checkInBounds(flickable, event, wallpapers.x, 0) && Helper.checkInBounds(c, event, offsetX, 0));

                if (wallpaper) {
                    Config.saved.wallpaper = wallpaper.path;
                }
            }
        }

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
