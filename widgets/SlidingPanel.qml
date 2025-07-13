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
    Binding on anchors.top {
        value: root.parent.top
        when: root.side == Config.panel.top
    }
    Binding on anchors.left {
        value: root.parent.top
        when: root.side == Config.panel.left
    }
    Binding on anchors.right {
        value: root.parent.top
        when: root.side == Config.panel.right
    }
    Binding on anchors.bottom {
        value: root.parent.top
        when: root.side == Config.panel.bottom
    }

    // centering
    Binding on anchors.horizontalCenter {
        when: !root.vertical
        value: root.parent.horizontalCenter
    }
    Binding on anchors.verticalCenter {
        when: root.vertical
        value: root.parent.verticalCenter
    }

    // hide it right away
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
