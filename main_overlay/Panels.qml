pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Controls

import "../config"
import "../modules/workspaces" as Workspaces
import "../modules/dashboard" as Dashboard
import "../modules/player" as Player
import "../modules/controls" as ControlsTray
import "../modules/tray" as Tray

// contains all sliding panels
Item {
    id: root

    anchors.fill: parent
    required property ShellScreen screen

    // workspaces
    Workspaces.Toast {
        id: workspaces

        screen: root.screen

        anchors.left: parent.left
        collapseTo: Config.toast.left
        anchors.verticalCenter: parent.verticalCenter
    }

    // dashboard
    Dashboard.Toast {
        id: dashboard

        screen: root.screen

        anchors.top: parent.top
        collapseTo: Config.toast.top
        anchors.horizontalCenter: parent.horizontalCenter
    }

    // player
    Player.Toast {
        id: player

        screen: root.screen

        anchors.top: parent.top
        collapseTo: Config.toast.top
        anchors.left: parent.left
        secondAnchor: Config.toast.left

        // syncWith: controls
    }

    // tray
    Tray.Toast {
        id: tray

        screen: root.screen

        anchors.top: parent.top
        collapseTo: Config.toast.top
        anchors.right: controls.left

        syncWith: controls
    }

    Tray.ContextMenus {
        toast: tray
    }

    // wifi/bt/battery
    ControlsTray.Toast {
        id: controls

        screen: root.screen

        anchors.top: parent.top
        collapseTo: Config.toast.top
        anchors.right: parent.right
        secondAnchor: Config.toast.right

        syncWith: tray
    }

    //

    // TripleToast {
    //     id: tray
    //     screen: root.screen

    //     anchors.top: parent.top
    //     collapseTo: Config.toast.top
    //     anchors.right: dashboard.left

    //     syncWith: player
    //     ignoreClicks: true

    //     compactConponent: Item {
    //         id: tray_container
    //         readonly property Tray publicIcons: icons
    //         readonly property MouseArea mous: mouse
    //         property string current: ""

    //         implicitHeight: Config.toast.size
    //         implicitWidth: icons.width + Config.toast.protrusions

    //         MouseArea {
    //             id: mouse
    //             anchors.fill: parent
    //             hoverEnabled: true

    //             Connections {
    //                 target: tray.mouseArea

    //                 function onPositionChanged(event) {
    //                     print(tray_container.current);
    //                     tray_container.current = icons.layout.children.filter(c => c instanceof TrayIcon).find(c => {
    //                         return Helper.checkInBounds(c, event, icons.x, icons.y);
    //                     })?.modelData.id ?? tray_container.current;
    //                 }

    //                 function onExited() {
    //                     tray_container.current = "";
    //                 }
    //             }
    //         }

    //         Tray {
    //             id: icons
    //             anchors.centerIn: parent
    //         }
    //     }

    //     fullComponent: Item {}
    // }

    // Repeater {
    //     id: tray_menus
    //     model: SystemTray.items

    //     TrayMenu {
    //         id: tm
    //         shown: modelData.id == tray.cLoader.item?.current
    //         anchors.top: tray.bottom
    //         x: tray.cLoader.item?.publicIcons.layout.children.find(c => c.modelData == this.modelData).x + tray.x - width / 2
    //         // HACK: make this normal
    //         Connections {
    //             target: tm.mouseArea

    //             function onContainsMouseChanged() {
    //                 if (tm.mouseArea.containsMouse && tray.state === Config.toast.state_hidden) {
    //                     tray.state = Config.toast.state_peek;
    //                     tray.debounceTimer.stop();
    //                 }
    //             }
    //         }
    //     }
    // }

    // // player

}
