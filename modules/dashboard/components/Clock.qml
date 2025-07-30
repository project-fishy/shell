import QtQuick

import "../../../widgets"
import "../../../logic"
import "../../../config"

Item {
    CustomText {
        text: Time.format("ddd, dd MMM hh:mm")
        color: Colors.current.on_background
        anchors.fill: parent
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }
}
