import "../../../../config"

import QtQuick
import Quickshell.Services.SystemTray

Item {
    id: root

    readonly property Column layout: layout_

    clip: true
    visible: width > 0 && height > 0

    implicitHeight: layout_.implicitHeight
    implicitWidth: layout_.implicitWidth

    Column {
        id: layout_

        spacing: Config.bar.tray.spacing

        Repeater {
            id: items

            model: SystemTray.items
            TrayIcon {}
        }
    }
}
