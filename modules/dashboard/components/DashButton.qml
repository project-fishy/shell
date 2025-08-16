import QtQuick

import "../../../widgets"
import "../../../config"

CustomRect {
    id: dash_button

    required property string icon

    property TapHandler tapHandler: th

    implicitWidth: 50
    implicitHeight: 50

    radius: Config.radius.small
    color: Colors.current.primary

    // onTapped gets overridden from elsewhere
    TapHandler {
        id: th
    }

    TextIcon {
        id: db_icon

        text: dash_button.icon
        color: Colors.current.on_primary

        anchors.centerIn: parent
    }
}
