import Quickshell
import QtQuick

import "../../widgets"
import "../../config"

Item {
    id: root

    anchors.fill: parent

    SlidingPanel {
        side: Config.panel.top

        child: Eminem {}
    }
}
