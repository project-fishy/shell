pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import "../../widgets"
import "../../config"
import "../../logic"

// this is supposed to be the panel at the top of the screen
// with a lot of controls.
Item {
    id: root
    implicitWidth: 640 // TODO: probably reverse idk
    implicitHeight: 480
    Item {
        anchors.fill: parent
        anchors.margins: 10
        // bars
        Visualizer {
            id: bars
            anchors.top: parent.top
            anchors.bottom: slider_volume.top
            implicitWidth: 100
            visible: parent.visible
        }

        // eminem gif
        Eminem {
            id: eminem
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.left: bars.right
            anchors.bottom: slider_volume.top
        }

        // volume
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
            anchors.right: parent.right
            anchors.bottom: parent.bottom
        }
    }
}
