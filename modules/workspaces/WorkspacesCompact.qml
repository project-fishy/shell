pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell

import "../../config"
import "../../widgets"
import "../../logic"

Item {
    id: root

    required property ShellScreen screen
    property ColumnLayout layout: layout_ // expose for mouse clicks

    readonly property var workspaces: Config.workspaces.filter(w => w.monitor == root.screen.name)
    readonly property list<Indicator> indicators: layout_.children.filter(c => c instanceof Indicator).sort((a, b) => a.y - b.y)

    implicitHeight: layout.implicitHeight + Config.toast.protrusions
    implicitWidth: Config.toast.size
    anchors.centerIn: parent

    CustomRect {
        id: slider

        property real marg: Config.spacing.small
        property Item selected // is set by indicator

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
                property var configuredWorkspaces: workspaces.map(w => w.name)
                property var otherWorkspaces: Hypr.workspacesForScreen(root.screen).filter(w => !configuredWorkspaces.includes(w.name)).map(w => w.name)

                values: [...Helper.flatten([configuredWorkspaces, otherWorkspaces])]
            }

            Indicator {
                selected_bg: slider
            }
        }
    }

    component Anim: NumberAnimation {
        easing.type: Easing.BezierSpline
        duration: Animations.duration.normal
        easing.bezierCurve: [0.38, 1.21, 0.22, 1, 1, 1]
    }
}
