pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

import "../../../../widgets"
import "../../../../config"
import "../../../../logic"

// workspaces section from the sidebar
Item {
    id: root

    required property ShellScreen screen

    property HyprlandMonitor monitor: Hypr.monitorFor(screen)
    property list<HyprlandWorkspace> currentWorkspaces: Hypr.workspacesForScreen(screen)

    readonly property int groupOffset: Math.floor((Hypr.currentWorkspace.id - 1) / Config.bar.workspaces) * Config.bar.workspaces

    implicitHeight: layout.implicitHeight
    implicitWidth: layout.implicitWidth

    anchors.horizontalCenter: parent.horizontalCenter

    // icons layout
    ColumnLayout {
        id: layout

        layer.enabled: true
        layer.smooth: true

        Repeater {
            model: root.currentWorkspaces

            Indicator {
                groupOffset: root.groupOffset
            }
        }
    }
}
