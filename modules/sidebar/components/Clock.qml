import QtQuick

import "../../../config"
import "../../../widgets"
import "../../../logic"

// sidebar clock
Column {
    id: root

    property string text_color: Colors.current.tertiary
    spacing: 10

    CustomText {
        anchors.horizontalCenter: parent.horizontalCenter

        text: Time.format("hh\nmm")
        color: root.text_color
    }
}
