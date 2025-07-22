import Quickshell
import QtQuick

import "../../widgets"
import "../../config"
import "../../logic"
import "../dashboard"
import "../sidebar/components/workspaces"
import "../sidebar/components/tray"

// contains all sliding panels
Item {
    id: root

    anchors.fill: parent
    required property ShellScreen screen

    // the dashboard
    TripleToast {
        id: calendar
        screen: root.screen

        anchors.top: parent.top
        collapseTo: Config.toast.top
        anchors.horizontalCenter: parent.horizontalCenter

        compactConponent: Item {
            implicitHeight: Config.toast.size
            implicitWidth: 200

            CustomText {
                text: Time.format("ddd, dd MMM hh:mm")
                color: Colors.current.on_background
                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
        }
        fullComponent: Dashboard {}
    }

    // the workspaces
    TripleToast {
        id: workspaces
        screen: root.screen

        anchors.left: parent.left
        collapseTo: Config.toast.left
        anchors.verticalCenter: parent.verticalCenter

        compactConponent: Item {
            implicitWidth: Config.toast.size
            implicitHeight: ws.height + Config.toast.protrusions

            Workspaces {
                id: ws
                screen: root.screen
                anchors.centerIn: parent
            }
        }

        ignoreClicks: true
        fullComponent: Item {}

        Connections {
            target: Hypr
            function onCurrentWorkspaceChanged() {
                if (Hypr.currentWorkspace.monitor === Hypr.monitorFor(root.screen))
                    workspaces.peek();
            }
        }
    }

    // tray and stuff
    TripleToast {
        id: power
        screen: root.screen

        anchors.top: parent.top
        collapseTo: Config.toast.top
        anchors.right: parent.right
        secondAnchor: Config.toast.right

        syncWith: dashboard

        compactConponent: Item {
            implicitHeight: Config.toast.size
            implicitWidth: Config.toast.size

            TextIcon {
                color: Colors.current.error
                text: "power_settings_new"
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }
        fullComponent: Item {
            implicitHeight: 300
            implicitWidth: 300
        }
    }

    TripleToast {
        id: dashboard
        screen: root.screen

        anchors.top: parent.top
        collapseTo: Config.toast.top
        anchors.right: power.left

        syncWith: tray

        compactConponent: Item {
            implicitHeight: Config.toast.size
            implicitWidth: dashIcons.width + Config.toast.protrusions

            Row {
                id: dashIcons
                anchors.centerIn: parent
                spacing: 5
                TextIcon {
                    text: "network_wifi_3_bar"
                }
                TextIcon {
                    text: "bluetooth"
                }
                TextIcon {
                    text: Charge.icon_text
                }
            }
        }
        fullComponent: Item {
            implicitHeight: 300
            implicitWidth: 300

            // HACK: this is not readable
            Item {
                id: first_row
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                implicitHeight: childrenRect.height + 10

                // volume
                CustomSlider {
                    id: slider_volume

                    text: "brand_awareness"

                    from: 0
                    to: 1

                    value: Volume.current
                    onMoved: Volume.set(value)
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.right: battery_rect.left
                    anchors.margins: 5
                }

                // brightness
                CustomSlider {
                    id: slider_brightness

                    text: "brightness_5"
                    value: Brightness.current

                    onValueChanged: {
                        Brightness.set(value);
                    }

                    onPressedChanged: {
                        Brightness.suppressUpdates = pressed;
                    }
                    anchors.left: parent.left
                    anchors.top: slider_volume.bottom
                    anchors.right: battery_rect.left
                    anchors.margins: 5
                }
                CustomRect {
                    id: battery_rect

                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    anchors.margins: 5
                    implicitWidth: parent.width / 3

                    color: Colors.current.secondary
                    radius: 10

                    Item {
                        anchors.fill: parent
                        anchors.margins: 5

                        CustomText {
                            text: Charge.current + "%"
                            color: Colors.current.on_primary
                            font.pointSize: 10
                        }
                        CustomText {
                            anchors.verticalCenter: parent.verticalCenter
                            text: Charge.timeLeft
                            color: Colors.current.on_primary
                        }
                        CustomText {
                            anchors.bottom: parent.bottom
                            text: Charge.draw
                            color: Colors.current.on_primary
                        }
                        TextIcon {
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter

                            text: Charge.icon_text
                            color: Colors.current.on_primary
                            font.pointSize: 30
                        }
                    }
                }
            }
            Grid {}
        }
    }
    TripleToast {
        id: tray
        screen: root.screen

        anchors.top: parent.top
        collapseTo: Config.toast.top
        anchors.right: dashboard.left

        syncWith: player
        ignoreClicks: true

        compactConponent: Item {
            implicitHeight: Config.toast.size
            implicitWidth: icons.width + Config.toast.protrusions
            Tray {
                id: icons
                anchors.centerIn: parent
            }
        }
        fullComponent: Item {}
    }

    // player
    TripleToast {
        id: player
        screen: root.screen

        anchors.top: parent.top
        anchors.right: tray.left
        collapseTo: Config.toast.top
        syncWith: power

        compactConponent: Item {
            implicitHeight: Config.toast.size
            implicitWidth: childrenRect.width + Config.toast.protrusions
            CustomText {
                anchors.centerIn: parent
                text: Player.now_playing
                color: Player.color
            }
        }

        fullComponent: Item {}
    }
}
