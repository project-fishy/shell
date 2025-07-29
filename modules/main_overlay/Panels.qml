pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Services.SystemTray
import QtQuick

import "../../widgets"
import "../../config"
import "../../logic"
import "../dashboard"
import "../calendar"
import "../workspaces"
import "../dashboard/components/tray"

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
        fullComponent: Calendar {}
    }

    // the workspaces
    TripleToast {
        id: workspaces
        screen: root.screen

        anchors.left: parent.left
        collapseTo: Config.toast.left
        anchors.verticalCenter: parent.verticalCenter

        compactConponent: WorkspacesCompact {
            screen: root.screen
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

        Connections {
            target: workspaces.mouseArea

            function onPressed(event) {
                let layout = workspaces.cLoader.item?.layout;
                let target = layout.children.find(c => {
                    let top = c.y;
                    let bot = top + c.height;

                    return top < event.y && event.y < bot;
                });

                if (!target?.modelData.active ?? false)
                    target?.modelData.activate();
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

        compactConponent: DashboardCompact {}
        fullComponent: DashboardFull {
            toast: dashboard
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
            id: tray_container
            readonly property Tray publicIcons: icons
            readonly property MouseArea mous: mouse
            property string current: ""

            implicitHeight: Config.toast.size
            implicitWidth: icons.width + Config.toast.protrusions

            MouseArea {
                id: mouse
                anchors.fill: parent
                hoverEnabled: true

                Connections {
                    target: tray.mouseArea

                    function onPositionChanged(event) {
                        print(tray_container.current);
                        tray_container.current = icons.layout.children.filter(c => c instanceof TrayIcon).find(c => {
                            return Helper.checkInBounds(c, event, icons.x, icons.y);
                        })?.modelData.id ?? tray_container.current;
                    }

                    function onExited() {
                        tray_container.current = "";
                    }
                }
            }

            Tray {
                id: icons
                anchors.centerIn: parent
            }
        }

        fullComponent: Item {}
    }

    Repeater {
        id: tray_menus
        model: SystemTray.items

        TrayMenu {
            id: tm
            shown: modelData.id == tray.cLoader.item?.current
            anchors.top: tray.bottom
            x: tray.cLoader.item?.publicIcons.layout.children.find(c => c.modelData == this.modelData).x + tray.x - width / 2
            // HACK: make this normal
            Connections {
                target: tm.mouseArea

                function onContainsMouseChanged() {
                    if (tm.mouseArea.containsMouse && tray.state === Config.toast.state_hidden) {
                        tray.state = Config.toast.state_peek;
                        tray.debounceTimer.stop();
                    }
                }
            }
        }
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
                x: Config.toast.protrusions / 2
                anchors.verticalCenter: parent.verticalCenter
                text: Player.now_playing
                color: Player.color
            }
        }

        fullComponent: Item {}
    }
}
