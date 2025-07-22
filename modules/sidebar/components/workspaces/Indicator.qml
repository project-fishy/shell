pragma ComponentBehavior: Bound
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
MouseArea {
    id: root

    required property int groupOffset
    required property HyprlandWorkspace modelData

    readonly property bool selected: modelData.active

    Layout.preferredWidth: childrenRect.width
    Layout.preferredHeight: childrenRect.height

    onClicked: modelData.activate()

    // workspace icon
    CustomText {
        id: wsIcon
        text: 0 < root.modelData.id && root.modelData.id <= 10 ? "一二三四五六七八九十"[root.modelData.id - 1] : root.modelData.id

        color: root.selected ? Colors.current.on_primary_container : Colors.current.on_background

        anchors.horizontalCenter: parent.horizontalCenter

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pointSize: 12

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

            AppIcon {
                color: wsIcon.color
            }
        }
    }
}
