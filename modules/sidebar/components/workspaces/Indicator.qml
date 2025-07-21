import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell

import "../../../../widgets"
import "../../../../config"
import "../../../../logic"

// a single workspace indicator
// with window icons
// [ ] animations?
// [ ] better color?
Item {
    id: root

    required property int groupOffset
    required property HyprlandWorkspace modelData

    readonly property bool selected: modelData.active

    Layout.preferredWidth: childrenRect.width
    Layout.preferredHeight: childrenRect.height

    // workspace icon
    TextIcon {
        id: wsIcon
        text: `counter_${root.modelData.id}`

        color: root.selected ? Colors.current.primary : Colors.current.tertiary

        anchors.horizontalCenter: parent.horizontalCenter

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        Behavior on color {
            ColorAnimation {}
        }
    }

    // window icons
    Column {
        id: layout

        anchors.top: wsIcon.bottom
        anchors.horizontalCenter: wsIcon.horizontalCenter

        spacing: -7

        Repeater {
            id: wIcons
            property var windows: Hypr.windowsForWorkspace(root.modelData)
            property var classes: windows.map(w => w.lastIpcObject.class)

            model: classes // TODO: inject more properties?

            AppIcon {}
        }
    }
}
