import QtQuick

import "../../widgets"
import "../../logic"
import "../../config"

TripleToast {
    id: player

    compactConponent: Item {
        implicitHeight: Config.toast.size
        implicitWidth: childrenRect.width + Config.toast.protrusions
        CustomText {
            x: Config.toast.protrusions / 2
            anchors.verticalCenter: parent.verticalCenter
            text: Player.now_playing
            color: Player.color
        }
    }

    fullComponent: Item {}
}
