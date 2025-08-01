import QtQuick

import "../../../widgets"
import "../../../config"

CustomRect {
    id: dash_button

    required property string icon

    implicitWidth: 50
    implicitHeight: 50

    radius: Config.radius.small
    color: Colors.current.primary

    TextIcon {
        id: db_icon

        text: dash_button.icon
        color: Colors.current.on_primary

        anchors.centerIn: parent
    }
}
