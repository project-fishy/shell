import QtQuick
import Quickshell
import Quickshell.Wayland
import "../config"

MouseArea {
    id: root

    required property int side
    required property Component child

    readonly property int hiddenWidth: vertical ? Config.border.thickness : loader.implicitWidth
    readonly property int hiddenHeight: vertical ? loader.implicitHeight : Config.border.thickness
    readonly property bool vertical: side === Config.panel.left || side === Config.panel.right

    property bool isVisible: false

    // place it at whichever side
    // TODO: this is probably not how its done
    anchors.left: side == Config.panel.left ? parent.left : null
    anchors.right: side == Config.panel.right ? parent.right : null
    anchors.bottom: side == Config.panel.bottom ? parent.bottom : null
    anchors.top: side == Config.panel.top ? parent.top : null

    // center
    anchors.horizontalCenter: !vertical ? parent.horizontalCenter : null
    anchors.verticalCenter: vertical ? parent.verticalCenter : null

    implicitWidth: hiddenWidth
    implicitHeight: hiddenHeight

    hoverEnabled: true
    preventStealing: true

    onEntered: {
        implicitHeight = loader.implicitHeight;
        implicitWidth = loader.implicitWidth;
    }
    onExited: {
        implicitHeight = hiddenHeight;
        implicitWidth = hiddenWidth;
    }

    state: "closed"

    Loader {
        id: loader
        sourceComponent: root.child
        active: true
        anchors.fill: parent
    }

    Behavior on implicitHeight {
        Anim {}
    }
    Behavior on implicitWidth {
        Anim {}
    }

    component Anim: NumberAnimation {
        easing.type: Easing.BezierSpline
        duration: 400
        easing.bezierCurve: [0.38, 1.21, 0.22, 1, 1, 1]
    }
}
