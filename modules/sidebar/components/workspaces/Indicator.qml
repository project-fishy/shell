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
    required property HyprlandWorkspace modelData

    property bool selected: activeWsId == modelData.id

    Layout.preferredWidth: childrenRect.width
    Layout.preferredHeight: childrenRect.height

    TextIcon {
        text: {
            let windows = Hyprland.toplevels.values.filter(i => i.workspace?.id === root.modelData.id);
            let classes = windows.map(w => w.lastIpcObject.class);

            // print(`>>> WS:${root.modelData.id}, WINDOWS:${classes}`);

            if (classes.includes("vivaldi-stable"))
                return "captive_portal";
            else if (classes.includes("Code"))
                return "code_blocks";
            else if (classes.includes("Spotify"))
                return "music_note";
            else
            // ovvupied but not cool
            if (classes.length > 0)
                return "accessible";
            return root.selected ? "adjust" : "fiber_manual_record";
        }

        color: root.selected ? Colors.current.text_color : Colors.current.text

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
