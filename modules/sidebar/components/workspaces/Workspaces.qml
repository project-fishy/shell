pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland

import "../../../../widgets"
import "../../../../config"

Item {
    id: root

    readonly property var activeWS: Hyprland.workspaces.values.reduce((acc, curr) => {
        acc[curr.id] = curr.lastIpcObject.windows > 0;
        return acc;
    })

    implicitHeight: layout.implicitHeight
    implicitWidth: layout.implicitWidth

    anchors.horizontalCenter: parent.horizontalCenter

    ColumnLayout {
        id: layout

        layer.enabled: true
        layer.smooth: true

        Repeater {
            model: Config.bar.workspaces

            // selected: root.activeWS
            Indicator {}
        }
    }
}
