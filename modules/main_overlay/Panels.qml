import Quickshell
import QtQuick

import "../../widgets"
import "../../config"
import "../dashboard"

Item {
    id: root

    anchors.fill: parent

    SlidingPanel {
        side: Config.panel.top

        child: Dashboard {}
    }
}
