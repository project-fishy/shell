import Quickshell
import QtQuick

import "../../widgets"
import "../../config"

Item {
    id: root

    anchors.fill: parent

    SlidingPanel {
        side: Config.panel.top

        child: CustomRect {
            implicitHeight: 300
            implicitWidth: 300
            color: "#0a0"
        }
    }
}
