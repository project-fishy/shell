import Quickshell
import QtQuick
import "../../config"
import "../../logic"
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

            // handle clicks
            onClicked: event => {
                if (event.button == Qt.LeftButton) {
                    // workspaces
                    let ws = checkWithinWorkspace(event);
                    if (ws != null) {
                        ws.modelData.activate();
                        return;
                    }
                }
            }

            // handle movement
            onPositionChanged: pos => {

                // tray
                let icon = checkWithinTrayIcon(pos);
                if (icon != null) {
                    let menuHeight = menus_.children.find(c => c.modelData?.id == icon.modelData.id).height;
                    let iconTop = tray.y + icon.y;

                    // set context menu info
                    menus_.yPos = iconTop + menuHeight > root.height ? root.height - menuHeight : iconTop;
                    menus_.current = icon.modelData.id;

                    return;
                } else
                    menus_.current = "";
            }

            // TODO: generalize probably
            function checkWithinWorkspace(pos): Indicator {
                for (const w of ws.layout.children) {
                    if (Helper.checkInBounds(w, pos, ws.x, ws.y))
                        return w;
                }
                return null;
            }

            function checkWithinTrayIcon(pos): TrayIcon {
                for (const i of tray.layout.children) {
                    if (Helper.checkInBounds(i, pos, tray.x, tray.y))
                        return i;
                }
                return null;
            }
        }
    }
}
