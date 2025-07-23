pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import "tray"

// generates and contains context menus for the sidebar
Item {
    id: root

    required property Tray tray
    required property string current // currently open menu, empty if none
    property int yPos // vertical position of current menu

    // create mouse region for opened menu
    property Region mouseRegion: Region {
        property Item target: root.children.find(t => t.modelData?.id == root.current) ?? null

        x: target?.x ?? 0
        y: target?.y ?? 0
        width: target?.width ?? 0
        height: target?.height ?? 0

        intersection: Intersection.Subtract
    }

    // create menus
    Repeater {

        model: SystemTray.items

        TrayMenu {
            id: menu

            shown: this.modelData.id == root.current
            y: root.yPos
        }
    }
}
