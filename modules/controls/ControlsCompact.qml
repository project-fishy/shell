import QtQuick

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
            // text: Network.active ?
            text: Network.active ? Network.getNetworkIcon(Network.active.strength ?? 0) : "wifi_off"
        }
        TextIcon {
            text: "bluetooth"
        }
        TextIcon {
            text: Charge.icon_text
        }
    }
}
