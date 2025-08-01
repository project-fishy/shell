pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import Quickshell.Io

import "../../logic"
import "../../widgets"

ClippingRectangle {
    id: root

    property list<string> paths
    property Item focused
    required property StackView stackview

    implicitHeight: parent.height
    implicitWidth: parent.width
    color: "transparent"
    radius: 10

    Flickable {
        id: flickable

        anchors.fill: parent
        flickableDirection: Flickable.VerticalFlick

        states: [
            State {
                name: "wallpapers"
                PropertyChanges {
                    grid.opacity: 1
                    scheme_loader.active: false
                    flickable.contentWidth: grid.width
                    flickable.contentHeight: grid.height
                }
            },
            State {
                name: "themes"
                PropertyChanges {
                    grid.opacity: 0
                    scheme_loader.active: true
                    flickable.contentHeight: scheme_loader.height
                    flickable.contentWidth: scheme_loader.width
                }
            },
            State {
                name: "done"
            }
        ]

        state: "wallpapers"

        Grid {
            id: grid

            width: root.width
            height: childrenRect.height
            columns: 2

            Repeater {
                model: root.paths

                CachedImage {
                    required property string modelData
                    path: modelData

                    width: root.width / 2
                    height: 70
                }
            }
        }

        Loader {
            id: scheme_loader

            active: false
            sourceComponent: SchemeDisplay {}
        }

        Process {
            id: scraper
            running: true
            command: ["sh", "-c", "ls /home/desant/Pictures/Wallpapers"]
            stdout: StdioCollector {
                onStreamFinished: root.paths = this.text.split("\n").filter(p => p != "").map(p => "/home/desant/Pictures/Wallpapers/" + p)
            }
        }
    }

    component SchemeDisplay: MatugenWrapper {
        id: schemeGen
        path: root.focused?.modelData
        property Column layout: schemes_layout

        implicitHeight: childrenRect.height
        implicitWidth: root.width

        Column {
            id: schemes_layout

            spacing: 5
            anchors.left: parent.left
            anchors.right: parent.right

            Repeater {
                model: schemeGen.schemes

                Rectangle {
                    id: scheme_display
                    required property MatugenWrapper.Scheme modelData

                    implicitHeight: 60
                    implicitWidth: schemeGen.width - 10
                    color: modelData.background
                    radius: 10

                    anchors.horizontalCenter: parent.horizontalCenter

                    Row {
                        anchors.fill: parent
                        spacing: 5

                        Rectangle {
                            color: scheme_display.modelData.primary
                            radius: height / 2
                            implicitHeight: scheme_display.height
                            implicitWidth: scheme_display.height
                        }
                        Rectangle {
                            color: scheme_display.modelData.secondary
                            radius: height / 2
                            implicitHeight: scheme_display.height
                            implicitWidth: scheme_display.height
                        }
                        Rectangle {
                            color: scheme_display.modelData.tertiary
                            radius: height / 2
                            implicitHeight: scheme_display.height
                            implicitWidth: scheme_display.height
                        }
                    }
                }
            }
        }
    }
    MouseArea {
        id: mous

        anchors.fill: parent
        propagateComposedEvents: true
        property real pressX
        property real pressY

        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onClicked: event => {
            if (event.button === Qt.LeftButton)
                if (flickable.state == "wallpapers") {
                    root.focused = grid.children.find(c => c.modelData && Helper.checkInBounds(c, event, -flickable.contentX, -flickable.contentY));
                    flickable.state = "themes";
                    flickable.contentX = 0;
                    flickable.contentY = 0;
                } else if (flickable.state == "themes") {
                    let scheme = scheme_loader.item.layout.children.find(c => Helper.checkInBounds(c, event, -flickable.contentX, -flickable.contentY)).modelData;
                    Quickshell.execDetached(["matugen", "image", "-t", `scheme-${scheme.modelData}`, scheme.pic]);
                    root.exit();
                }
            if (event.button === Qt.RightButton)
                if (flickable.state === "themes")
                    flickable.state = "wallpapers";
                else
                    root.exit();
            event.accepted = true;
        }
    }
    function exit() {
        root.stackview.pop();
    }
}
