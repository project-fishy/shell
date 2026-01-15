pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import Quickshell

import "../../widgets"
import "../../logic"
import "../../config"

Item {
    id: root

    readonly property real barThickness: 5
    readonly property real knobThickness: 7
    readonly property real knobOutline: 2

    CustomText {
        id: progressText

        text: Player.current?.position
        anchors.verticalCenter: slider.verticalCenter
        anchors.right: slider.left
    }

    MusicSlider {
        id: slider

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5

        width: root.width * 0.7
    }

    // CustomRect {
    //     color: "#ffffff"
    //     anchors.fill: parent
    // }

    CustomText {
        id: totalText

        text: Player.current?.length
        color: Colors.current.on_background
        anchors.verticalCenter: slider.verticalCenter
        anchors.left: slider.right
    }

    component MusicSlider: Slider {
        handle: CustomRect {
            color: Colors.current.primary

            implicitWidth: root.knobThickness
            implicitHeight: root.knobThickness
            radius: root.knobThickness
        }
    }
}
