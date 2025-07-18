import QtQuick
import Quickshell
import Quickshell.Wayland
import "../config"

// the cool slidy thing wrapper.
MouseArea {
    id: root

    required property int side // from Config.panel.[...] determines where it will be placed
    // TODO: offset?
    required property Component child // TODO: rename to sourceComponent? for consistency?

    // determine some properties
    readonly property int hiddenWidth: vertical ? Config.border.thickness : loader.implicitWidth + Config.border.thickness * 2
    readonly property int hiddenHeight: vertical ? loader.implicitHeight + Config.border.thickness * 2 : Config.border.thickness
    readonly property bool vertical: side === Config.panel.left || side === Config.panel.right

    property bool isVisible: false

    // place it at whichever side
    Binding on anchors.top {
        value: root.parent.top
        when: root.side == Config.panel.top
    }
    Binding on anchors.left {
        value: root.parent.left
        when: root.side == Config.panel.left
    }
    Binding on anchors.right {
        value: root.parent.right
        when: root.side == Config.panel.right
    }
    Binding on anchors.bottom {
        value: root.parent.bottom
        when: root.side == Config.panel.bottom
    }

    // centering // TODO: offset
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

    hoverEnabled: true // mouse detection
    preventStealing: true // TODO: idk if i need this

    // show/hide
    // TODO: make functions probably
    onEntered: {
        implicitHeight = loader.implicitHeight + Config.border.thickness * 2 + Config.panel.outline;
        implicitWidth = loader.implicitWidth + (Config.border.thickness + Config.panel.outline) * 2;
        isVisible = true;
    }
    onExited: {
        implicitHeight = hiddenHeight;
        implicitWidth = hiddenWidth;
        isVisible = false;
    }

    // child loader
    // wrap it in the bg for now
    RoundedBg {
        hasBorder: root.isVisible
        Loader {
            id: loader
            sourceComponent: root.child
            active: true
            anchors.fill: parent
        }
    }

    // animations
    Behavior on implicitHeight {
        Anim {}
    }
    Behavior on implicitWidth {
        Anim {}
    }

    component Anim: NumberAnimation {
        easing.type: Easing.BezierSpline
        duration: Animations.duration.normal
        easing.bezierCurve: [0.38, 1.21, 0.22, 1, 1, 1]
    }
}
