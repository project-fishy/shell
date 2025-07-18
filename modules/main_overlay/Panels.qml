import Quickshell
import QtQuick

import "../../widgets"
import "../../config"
import "../dashboard"

// contains all sliding panels
Item {
    id: root

    anchors.fill: parent

    // the dashboard
    SlidingPanel {
        side: Config.panel.top

        child: Dashboard {}
    }
}
