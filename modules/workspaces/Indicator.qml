pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland

import "../../widgets"
import "../../config"
import "../../logic"

// a single workspace indicator
// with window icons
// [ ] animations?
// [ ] better color?
Item {
    id: root

    required property string modelData // workspace name
    required property Item selected_bg

    property var workspace: Hyprland.workspaces.values.find(w => w.name == modelData)

    readonly property bool selected: workspace?.active ?? false

    Layout.preferredWidth: childrenRect.width
    Layout.preferredHeight: childrenRect.height

    onSelectedChanged: {
        if (selected)
            selected_bg.selected = root;
    }

    function activate() {
        if (workspace && !workspace.active)
            workspace.activate();
        if (!workspace)
            if (!modelData.startsWith("special:"))
                Hyprland.dispatch(`workspace ${modelData}`);
    }

    // workspace icon
    CustomText {
        id: wsIcon
        text: {
            if (root.modelData.includes("special:"))
                return "死";
            else
                return Config.workspaces.find(w => w.name == root.modelData)?.indicator ?? ".";
        }
        color: root.selected ? Colors.current.on_primary : Colors.current.on_background

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

            model: root.workspace ? Hypr.windowsForWorkspace(root.workspace).map(w => w.lastIpcObject) : []

            AppIcon {
                color: wsIcon.color
                anchors.horizontalCenter: layout.horizontalCenter
            }
        }
    }
}
