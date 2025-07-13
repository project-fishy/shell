import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell

import "../../../../widgets"
import "../../../../config"

Item {
    id: root

    required property var index
    // required property int selected
    property int active: Hyprland.focusedWorkspace?.id ?? 1

    Layout.preferredWidth: childrenRect.width
    Layout.preferredHeight: childrenRect.height

    // looks better with this
    // Layout.alignment: parent.horizontalCenter

    TextIcon {
        text: "accessible"
        // text: root.index + 1

        color: root.active == root.index + 1 ? Colors.current.text_color : Colors.current.text
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
