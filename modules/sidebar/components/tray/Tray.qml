import "../../../../config"

import QtQuick
import Quickshell.Services.SystemTray

Item {
    id: root

    readonly property Repeater items: items

    clip: true
    visible: width > 0 && height > 0

    implicitHeight: layout.implicitHeight
    implicitWidth: layout.implicitWidth

    Column {
        id: layout

        spacing: Config.bar.tray.spacing

        Repeater {
            id: items

            model: SystemTray.items
            TrayIcon {}
        }
    }
}
