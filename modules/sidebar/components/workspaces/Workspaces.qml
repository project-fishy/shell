pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

import "../../../../widgets"
import "../../../../config"

// workspaces section from the sidebar
Item {
    id: root

    required property ShellScreen screen
    // TODO: move to hyprland wrapper
    property HyprlandMonitor monitor: Hyprland.monitors.values.find(m => m.name == screen.name)
    property list<HyprlandWorkspace> currentWorkspaces: Hyprland.workspaces.values.filter(w => w.monitor === root.monitor)

    readonly property var activeWS: Hyprland.workspaces.values.reduce((acc, curr) => {
        acc[curr.id] = curr.lastIpcObject.windows > 0;
        return acc;
    })

    readonly property int activeWsId: Hyprland.focusedWorkspace?.id ?? 1
    readonly property int groupOffset: Math.floor((activeWsId - 1) / Config.bar.workspaces) * Config.bar.workspaces

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
                activeWsId: root.activeWsId
            }
        }
    }

    // TODO: move to hyprland wrapper
    Connections {
        target: Hyprland

        function onRawEvent(event: HyprlandEvent): void {
            Hyprland.refreshMonitors();
            Hyprland.refreshWorkspaces();
            Hyprland.refreshToplevels();
        }
    }
}
