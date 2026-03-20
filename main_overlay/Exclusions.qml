pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Hyprland
import QtQuick

import "../widgets"
import "../config"
import "../logic"

// this reserves space for the borders and sidebar
Scope {
    id: root

    required property var screen

    property bool excludeTop: false

    // make windows avoid the left panel
    // ExclusionZone {
    //     anchors.left: true
    //     exclusiveZone: Config.toast.size + Config.spacing.smaller * 2
    // }

    Loader {
        active: root.excludeTop

        sourceComponent: ExclusionZone {
            anchors.top: true
            exclusiveZone: Config.toast.size + Config.spacing.smaller
        }
    }

    Hypr.Shortcut {
        name: "excludeTop"
        description: "Toggle top exclusion zone"

        onPressed: {
            root.excludeTop = !root.excludeTop;
            Qt.callLater(Hyprland.refreshToplevels());
            // Hyprland.refreshToplevels();
        }
    }

    // avoid the other borders
    // ExclusionZone {
    //     anchors.right: true
    // }
    //
    // ExclusionZone {
    //     anchors.top: true
    // }
    //
    // ExclusionZone {
    //     anchors.bottom: true
    // }

    component ExclusionZone: CustomWindow {
        screen: root.screen
        name: "exclusion"
        exclusiveZone: Config.border.thickness

        // removes weird unclickable zones on top and bottom
        implicitHeight: 0
        implicitWidth: 0
    }
}
