import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell

import "../../../../widgets"
import "../../../../config"

Item {
    id: root

    required property var index
    required property int activeWsId
    required property int groupOffset

    property bool selected: root.activeWsId == root.index + 1

    Layout.preferredWidth: childrenRect.width
    Layout.preferredHeight: childrenRect.height

    // looks better with this
    // Layout.alignment: parent.horizontalCenter

    TextIcon {
        text: {
            let items = Hyprland.toplevels.values.filter(i => i.workspace?.id === root.index + 1);
            let windows = items.map(w => w.lastIpcObject.class);

            // print(`ws:${root.index} - ${windows} / ${windows.length}`);

            if (windows.includes("vivaldi-stable"))
                return "captive_portal";
            else if (windows.includes("Code"))
                return "code_blocks";
            else if (windows.includes("Spotify"))
                return "music_note";
            else
            // ovvupied but not cool
            if (windows.length > 0)
                return "accessible";
            return root.selected ? "adjust" : "fiber_manual_record";
        }
        // text: root.index + 1

        color: root.selected ? Colors.current.text_color : Colors.current.text

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
