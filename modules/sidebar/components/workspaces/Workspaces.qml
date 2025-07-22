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

    CustomRect {
        id: slider
        property Item selected: layout_.children.find(c => c.selected ?? false)
        property real marg: 5

        x: selected.x - marg
        y: selected.y - marg
        implicitWidth: selected.width + marg * 2
        implicitHeight: selected.height + marg * 2

        color: Colors.current.primary_container
        radius: width / 2

        Behavior on x {
            Anim {}
        }
        Behavior on y {
            Anim {}
        }
        Behavior on implicitWidth {
            Anim {}
        }
        Behavior on implicitHeight {
            Anim {}
        }
    }

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

    component Anim: NumberAnimation {
        easing.type: Easing.BezierSpline
        duration: Animations.duration.normal
        easing.bezierCurve: [0.38, 1.21, 0.22, 1, 1, 1]
    }
}
