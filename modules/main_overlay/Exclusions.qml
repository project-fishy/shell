pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import "../../widgets"
import "../../config"

Scope {
    id: root
    required property var screen
    required property Item bar

    // make windows avoid the left panel
    ExclusionZone {
        anchors.left: true
        exclusiveZone: root.bar.implicitWidth// + Config.border.thickness
    }

    // avoid the other borders
    ExclusionZone {
        anchors.right: true
    }

    ExclusionZone {
        anchors.top: true
    }

    ExclusionZone {
        anchors.bottom: true
    }

    component ExclusionZone: CustomWindow {
        screen: root.screen
        name: "exclusion"
        exclusiveZone: Config.border.thickness

        // removes weird unclockable zones on top and bottom
        implicitHeight: 0
        implicitWidth: 0
    }
}
