pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import "../../widgets"
import "../../config"
import "../../logic"

Item {
    id: root
    implicitWidth: 640
    implicitHeight: 480

    property int default_vol
    property int default_br

    Eminem {
        id: eminem
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.bottom: slider_volume.top
    }

    CustomSlider {
        id: slider_volume

        text: "brand_awareness"

        from: 0
        to: 1

        value: Volume.current
        onMoved: Volume.set(value)

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: slider_brightness.top
    }

    // property string watching: proc.text

    CustomSlider {
        id: slider_brightness

        text: "brightness_5"
        value: Brightness.current

        onValueChanged: {
            Brightness.set(value);
        }

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
    }
}
