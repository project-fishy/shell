import QtQuick
import Quickshell

import "../../config"
import "../../widgets"
import "../../logic"

Item {
    implicitHeight: Config.toast.size
    implicitWidth: dashIcons.width + Config.toast.protrusions

    Row {
        id: dashIcons
        anchors.centerIn: parent
        spacing: 5
        TextIcon {
            text: "network_wifi_3_bar"
        }
        TextIcon {
            text: "bluetooth"
        }
        TextIcon {
            text: Charge.icon_text
        }
    }
}
