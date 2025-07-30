import Quickshell
import QtQuick

import "../../widgets"
import "../../config"
import "../../logic"

TripleToast {
    id: root

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
                target: root.mouseArea

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
