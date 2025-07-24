import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

import "../../config"
import "../../widgets"
import "../../logic"

Item {
    id: root

    required property ShellScreen screen
    property ColumnLayout layout: layout_ // expose for mouse clicks

    readonly property list<HyprlandWorkspace> currentWorkspaces: Hypr.workspacesForScreen(screen).filter(w => w.name && w.name != "").sort((a, b) => a.id - b.id)
    readonly property list<Indicator> indicators: layout_.children.filter(c => c instanceof Indicator).sort((a, b) => a.y - b.y)

    implicitHeight: layout.implicitHeight + Config.toast.protrusions
    implicitWidth: Config.toast.size
    anchors.centerIn: parent

    // anchors.horizontalCenter: parent.horizontalCenter

    CustomRect {
        id: slider

        property real marg: 5
        // HACK: is this hacky? probably. does it work? hell yeah
        property Item selected

        Binding on selected {
            when: root.currentWorkspaces.some(w => w.active)
            value: root.indicators[root.currentWorkspaces.findIndex(w => w.active)]
        }

        y: selected?.y + marg ?? 0
        implicitWidth: selected?.width + marg * 2 ?? 0
        implicitHeight: selected?.height + marg * 2 ?? 0
        anchors.horizontalCenter: root.horizontalCenter

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
        anchors.centerIn: parent

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
