pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import "../../widgets"
import "../../config"

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

    Process {
        id: br

        running: true
        command: ["brightnessctl", "-m", "g"]

        stdout: StdioCollector {
            onStreamFinished: {
                root.default_br = parseInt(this.text);
                print(`${root.default_br}`);
            }
        }
    }

    Process {
        id: vol

        running: true
        command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]

        stdout: StdioCollector {
            onStreamFinished: {
                root.default_vol = Math.floor(parseFloat(this.text.split(" ")[1]) * 100);
                print(`${this.text}`);
            }
        }
    }

    Slider {
        id: slider_volume

        text: "brand_awareness"
        perc: parseInt(root.default_vol)
        command: ["wpctl", "set-volume", "-l", "1", "@DEFAULT_AUDIO_SINK@"]

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: slider_brightness.top
    }

    Slider {
        id: slider_brightness

        text: "brightness_5"
        perc: 80
        command: ["brightnessctl", "set"]

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
    }
}
