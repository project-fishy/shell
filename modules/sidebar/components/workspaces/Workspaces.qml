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
    property ColumnLayout layout: layout_ // expose for mouse clicks

    readonly property HyprlandMonitor monitor: Hypr.monitorFor(screen)
    readonly property list<HyprlandWorkspace> currentWorkspaces: Hypr.workspacesForScreen(screen)

    readonly property int groupOffset: Math.floor((Hypr.currentWorkspace.id - 1) / Config.bar.workspaces) * Config.bar.workspaces

    implicitHeight: layout.implicitHeight
    implicitWidth: layout.implicitWidth

    anchors.horizontalCenter: parent.horizontalCenter

    // icons layout
    ColumnLayout {
        id: layout_

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
