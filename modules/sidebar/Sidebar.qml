import Quickshell
import QtQuick
import "../../config"
import "components"
import "components/workspaces"
import "components/tray"

// sidebar.
Item {
    id: root
    required property ShellScreen screen

    property ContextMenus menus: menus_ // expose for mouse regions

    anchors.top: parent.top
    anchors.left: parent.left
    anchors.bottom: parent.bottom

    implicitWidth: Config.bar.width

    // the bar itself
    Rectangle {
        anchors.fill: parent

        color: Colors.current.background

        // workspace indicators
        Workspaces {
            id: ws

            screen: root.screen

            anchors.top: parent.top
            anchors.topMargin: Config.bar.margins
        }

        // tray icons
        Tray {
            id: tray

            anchors.bottom: clock.top
            anchors.horizontalCenter: parent.horizontalCenter
        }

        // context menus for tray and whatnot
        ContextMenus {
            id: menus_

            tray: tray
            yPos: 50
            current: ""
        }

        // clock
        Clock {
            id: clock

            anchors.bottom: battery.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: Config.bar.margins
        }

        // battery indicator
        Battery {
            id: battery
            anchors.bottom: power.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: Config.bar.margins
        }

        // power button
        Power {
            id: power
            anchors.bottom: parent.bottom
        }

        // this should handle any and all input for the sidebar
        MouseArea {
            id: mouseHandler

            anchors.fill: parent
            hoverEnabled: true

            // check where the mouse is
            onPositionChanged: pos => {
                // tray
                let found = false;
                for (const i of tray.layout.children) {
                    let iconTop = tray.y + i.y;
                    let iconBot = iconTop + i.height;

                    if (iconTop < pos.y && pos.y < iconBot) {
                        let menuHeight = menus.children.find(c => c.modelData?.id == i.modelData.id).height;
                        menus_.yPos = iconTop + menuHeight > root.height ? root.height - menuHeight : iconTop;

                        menus_.current = i.modelData.id;

                        found = true;
                        break;
                    }
                }
                if (!found) {
                    menus_.current = "";
                }
            }
        }
    }
}
