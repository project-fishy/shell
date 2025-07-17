import QtQuick
import Quickshell
import Quickshell.Services.UPower

import "../../../widgets"
import "../../../config"
import "../../../logic"

// battery icon thing
// TODO: move logic
Column {
    id: root

    // icon
    TextIcon {
        text: Charge.icon_text
        color: Colors.current.text_color
        CustomText {
            text: Charge.current + "%"
            font.pointSize: 8
            styleColor: Colors.current.background
            style: Text.Outline
            anchors.centerIn: parent
        }
    }

    // charge text
    CustomText {
        text: Charge.timeLeft
        anchors.horizontalCenter: root.horizontalCenter
        font.pointSize: 6
    }
}
