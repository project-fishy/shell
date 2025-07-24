import Quickshell
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
        fullComponent: DashboardFull {}
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
                x: Config.toast.protrusions / 2
                anchors.verticalCenter: parent.verticalCenter
                text: Player.now_playing
                color: Player.color
            }
        }

        fullComponent: Item {}
    }
}
