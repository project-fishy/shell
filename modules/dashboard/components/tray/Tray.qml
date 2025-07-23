import "../../../../config"

import QtQuick
import Quickshell.Services.SystemTray

// generates tray icons
Item {
    id: root

    readonly property Row layout: layout_

    clip: true
    visible: width > 0 && height > 0

    // auto generate size based on icons
    implicitHeight: layout_.implicitHeight
    implicitWidth: layout_.implicitWidth

    // TODO: add outline? or bg?
    Row {
        id: layout_

        spacing: Config.bar.tray.spacing

        Repeater {
            id: items

            model: SystemTray.items
            TrayIcon {}
        }
    }
}
