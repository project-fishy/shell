import QtQuick
import Quickshell

import "../../config"
import "../../widgets"
import "../../logic"

Item {
    implicitHeight: 300
    implicitWidth: 300

    // HACK: this is not readable
    Item {
        id: first_row
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        implicitHeight: childrenRect.height + 10

        // volume
        CustomSlider {
            id: slider_volume

            text: "brand_awareness"

            from: 0
            to: 1

            value: Volume.current
            onMoved: Volume.set(value)
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.right: battery_rect.left
            anchors.margins: 5
        }

        // brightness
        CustomSlider {
            id: slider_brightness

            text: "brightness_5"
            value: Brightness.current

            onValueChanged: {
                Brightness.set(value);
            }

            onPressedChanged: {
                Brightness.suppressUpdates = pressed;
            }
            anchors.left: parent.left
            anchors.top: slider_volume.bottom
            anchors.right: battery_rect.left
            anchors.margins: 5
        }
        CustomRect {
            id: battery_rect

            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.margins: 5
            implicitWidth: parent.width / 3

            color: Colors.current.secondary
            radius: 10

            Item {
                anchors.fill: parent
                anchors.margins: 5

                CustomText {
                    text: Charge.current + "%"
                    color: Colors.current.on_primary
                    font.pointSize: 10
                }
                CustomText {
                    anchors.verticalCenter: parent.verticalCenter
                    text: Charge.timeLeft
                    color: Colors.current.on_primary
                }
                CustomText {
                    anchors.bottom: parent.bottom
                    text: Charge.draw
                    color: Colors.current.on_primary
                }
                TextIcon {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter

                    text: Charge.icon_text
                    color: Colors.current.on_primary
                    font.pointSize: 30
                }
            }
        }
    }
    Grid {}
}
