import Quickshell
import QtQuick
import "../../config"
import "components"
import "components/workspaces"
import "components/tray"

Item {
    id: root
    required property ShellScreen screen

    property ContextMenus menus: menus_

    anchors.top: parent.top
    anchors.left: parent.left
    anchors.bottom: parent.bottom

    implicitWidth: Config.bar.width

    Rectangle {
        anchors.fill: parent

        color: Colors.current.background

        Workspaces {
            id: ws

            screen: root.screen

            anchors.top: parent.top
            anchors.topMargin: Config.bar.margins
        }

        // TEST {
        //     anchors.top: ws.bottom
        //     anchors.bottom: clock.top
        //     anchors.horizontalCenter: parent.horizontalCenter
        //     implicitWidth: root.implicitWidth
        // }

        Tray {
            id: tray

            anchors.bottom: clock.top
            anchors.horizontalCenter: parent.horizontalCenter
        }

        ContextMenus {
            id: menus_

            tray: tray
            yPos: 50
            current: ""
        }

        Clock {
            id: clock

            anchors.bottom: battery.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: Config.bar.margins
        }

        Battery {
            id: battery
            anchors.bottom: power.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: Config.bar.margins
        }

        Power {
            id: power
            anchors.bottom: parent.bottom
        }

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
                        menus_.current = i.modelData.id;
                        menus_.yPos = iconTop;
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

    component TEST: Item {
        id: root

        Rectangle {
            id: rect

            anchors.fill: parent
            color: Colors.current.accent
        }

        MouseArea {
            id: mous
            anchors.fill: parent

            onPressed: event => {
                rect.color = Colors.current.text;
            }

            onEntered: event => {
                rect.color = Colors.current.accent;
            }
        }
    }
}
