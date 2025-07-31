import QtQuick
import Quickshell

import "../../../widgets"
import "../../../config"

CustomRect {
    id: dash_button

    required property string icon
    // required property string text

    implicitWidth: 50
    implicitHeight: 50
    radius: Config.radius.small

    color: Colors.current.primary

    TextIcon {
        id: db_icon
        text: dash_button.icon
        color: Colors.current.on_primary
        // anchors.verticalCenter: parent.verticalCenter
        // x: y
        anchors.centerIn: parent
    }
    // CustomText {
    //     id: db_text
    //     text: dash_button.text
    //     color: Colors.current.on_primary
    //     anchors.verticalCenter: parent.verticalCenter
    //     x: db_icon.x * 2 + db_icon.width
    // }
}
