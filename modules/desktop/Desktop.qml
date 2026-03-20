import Quickshell
import Quickshell.Wayland

import QtQuick

import "../../widgets"
import "../../config"
import "../../logic"

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

            ClockText {
                id: clock

                text: Time.format("hh:mm")
                font.pointSize: 50
                font.bold: true

                anchors.horizontalCenter: parent.horizontalCenter

                y: 170
            }

            ClockText {
                id: day

                text: Time.format("dddd, dd MMMM")
                font.pointSize: 12
                font.italic: true
                font.bold: true

                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: clock.bottom
                anchors.topMargin: -13
            }

            ClockText {
                id: ampm

                text: Time.format("A")
                font.pointSize: 13
                font.bold: true

                anchors.left: clock.right
                anchors.top: clock.top
                anchors.topMargin: 30
                anchors.leftMargin: 5
            }

            // NOTE: if cava starts too soon it crashes immediately
            Timer {
                id: visDebounce

                running: true
                repeat: false

                interval: 2000

                onTriggered: {
                    if (Charge.charging) {
                        visTop.active = true;
                        visBot.active = true;
                    } else {
                        visTop.active = false;
                        visBot.active = false;
                    }
                }
            }

            Connections {
                target: Charge

                function onChargingChanged() {
                    visDebounce.start();
                }
            }

            Item {
                id: clockRect

                anchors.top: clock.top
                anchors.bottom: day.bottom
                width: clock.width
                anchors.horizontalCenter: clock.horizontalCenter
            }

            Item {
                id: visContainer

                anchors.centerIn: clockRect

                width: clock.width
                height: clock.height + 75
            }

            Vis {
                id: visTop

                anchors.top: visContainer.top
                anchors.bottom: clock.top
                anchors.horizontalCenter: visContainer.horizontalCenter
                anchors.bottomMargin: Config.spacing.small

                flipV: true
                flipH: true

                width: clock.width
            }

            Vis {
                id: visBot

                anchors.top: day.bottom
                anchors.topMargin: Config.spacing.small
                anchors.bottom: visContainer.bottom
                anchors.horizontalCenter: visContainer.horizontalCenter
                width: clock.width
            }
        }
    }

    component Vis: Visualizer {
        color: Colors.current.on_background
        active: false
        bars: 15
        framerate: 60
    }

    component ClockText: CustomText {
        color: Colors.current.on_background

        font.family: "Maple Mono CN"
    }
}
