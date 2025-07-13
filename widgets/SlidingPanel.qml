import QtQuick
import Quickshell
import Quickshell.Wayland
import "../config"

CustomWindow {
    id: root

    required property int side
    required property Component child

    anchors.left: side == Config.panel.left
    anchors.right: side == Config.panel.right
    anchors.bottom: side == Config.panel.bottom
    anchors.top: side == Config.panel.top

    readonly property bool vertical: side === Config.panel.left || side === Config.panel.right
    property bool visible: false

    readonly property int hiddenWidth: vertical ? Config.border.thickness : loader.implicitWidth
    readonly property int hiddenHeight: vertical ? loader.implicitHeight : Config.border.thickness

    WlrLayershell.exclusionMode: ExclusionMode.Ignore

    implicitWidth: hiddenWidth
    implicitHeight: hiddenHeight

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onEntered: root.visible = true
        onExited: root.visible = false
    }

    Loader {
        id: loader
        sourceComponent: root.child
        active: true
        anchors.fill: parent
    }

    onVisibleChanged: {
        if (root.visible) {
            root.implicitHeight = loader.implicitHeight;
            root.implicitWidth = loader.implicitWidth;
        } else {
            root.implicitHeight = root.hiddenHeight;
            root.implicitWidth = root.hiddenWidth;
        }
    }
}
