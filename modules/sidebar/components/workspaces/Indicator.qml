import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell

import "../../../../widgets"
import "../../../../config"

MouseArea {
    id: root

    required property var index
    required property int activeWsId
    required property int groupOffset
    required property HyprlandWorkspace modelData

    property bool selected: activeWsId == modelData.id

    Layout.preferredWidth: childrenRect.width
    Layout.preferredHeight: childrenRect.height

    TextIcon {
        id: wsIcon
        text: `counter_${root.modelData.id}`

        color: root.selected ? Colors.current.text_color : Colors.current.text

        anchors.horizontalCenter: parent.horizontalCenter

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
    Column {
        id: layout

        anchors.top: wsIcon.bottom
        anchors.horizontalCenter: wsIcon.horizontalCenter

        spacing: -7

        Repeater {
            id: wIcons
            property var windows: Hyprland.toplevels.values.filter(i => i.workspace?.id === root.modelData.id)
            property var classes: windows.map(w => w.lastIpcObject.class)

            model: classes

            AppIcon {}
        }
    }
}
