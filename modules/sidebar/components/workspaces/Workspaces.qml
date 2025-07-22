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

    readonly property list<HyprlandWorkspace> currentWorkspaces: Hypr.workspacesForScreen(screen)

    implicitHeight: layout.implicitHeight
    implicitWidth: layout.implicitWidth

    anchors.horizontalCenter: parent.horizontalCenter

    CustomRect {
        id: slider

        property real marg: 5
        // HACK: is this hacky? probably. does it work? hell yeah
        property Item selected: {
            let indicators = layout_.children.filter(c => c instanceof Indicator);
            let index = root.currentWorkspaces.findIndex(w => w.active);

            return indicators[index];
        }

        x: selected?.x - marg ?? 0
        y: selected?.y - marg ?? 0
        implicitWidth: selected?.width + marg * 2 ?? 0
        implicitHeight: selected?.height + marg * 2 ?? 0

        color: Colors.current.primary
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
            model: ScriptModel {
                values: [...root.currentWorkspaces]
            }

            Indicator {}
        }
    }

    component Anim: NumberAnimation {
        easing.type: Easing.BezierSpline
        duration: Animations.duration.normal
        easing.bezierCurve: [0.38, 1.21, 0.22, 1, 1, 1]
    }
}
