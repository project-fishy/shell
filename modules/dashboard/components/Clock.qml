import QtQuick

import "../../../widgets"
import "../../../logic"
import "../../../config"

Item {
    id: root

    required property bool showWeather

    CustomText {
        text: Time.format("ddd, dd MMM hh:mm")
        color: Colors.current.on_background
        anchors.fill: parent
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        visible: !showWeather
    }

    CustomText {
        text: `${Weather.description}, ${Weather.tempC}`
        color: Colors.current.on_background
        font.italic: true
        anchors.fill: parent
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        visible: root.showWeather
    }
}
