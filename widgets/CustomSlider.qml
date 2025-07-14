import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Io

import "../widgets"
import "../config"

Slider {
    id: root

    required property string text

    from: 0
    to: 100

    implicitHeight: Config.slider.thickness

    // override elements (https://doc.qt.io/qt-6/qml-qtquick-controls-slider-members.html)

    handle: Item {
        id: knob

        implicitWidth: root.height
        implicitHeight: root.height

        x: root.visualPosition * (root.availableWidth - width)

        CustomRect {
            anchors.fill: parent
            color: Colors.current.text_color

            radius: root.height / 2

            CustomText {
                text: root.pressed ? root.value : root.text
                font.family: !root.pressed ? "Material Symbols Rounded" : "Monaspace Argon"
                font.pointSize: root.pressed ? 10 : 20
                color: Colors.current.background

                horizontalAlignment: Text.AlignHCenter
                anchors.centerIn: parent
            }
        }
    }

    background: Item {
        CommonRect {
            id: filled

            color: Colors.current.accent

            anchors.left: parent.left
            // anchors.right: knob.horizontalCenter
            implicitWidth: knob.x + root.height / 2

            topRightRadius: 0
            bottomRightRadius: 0
        }

        CommonRect {
            id: bar

            color: Colors.current.dull
            anchors.right: parent.right
            anchors.left: filled.right
            topLeftRadius: 0
            bottomLeftRadius: 0
        }
    }
    component CommonRect: CustomRect {
        radius: Config.slider.thickness / 2
        // anchors.top: parent.top
        // anchors.bottom: parent.bottom
        anchors.verticalCenter: parent.verticalCenter
        implicitHeight: root.height
    }
}

// MouseArea {
//     id: root

//     required property string text
//     required property int perc

//     required property list<string> command

//     implicitHeight: Config.slider.thickness

//     drag {
//         // active: dragActive
//         target: knob
//         axis: Drag.XAxis
//         minimumX: 0
//         maximumX: root.width - Config.slider.thickness
//         threshold: 0
//     }

//     Process {
//         id: proc

//         running: false
//         command: [].concat.apply([], [root.command, root.perc + "%"])

//         stdout: StdioCollector {
//             onStreamFinished: console.log(`line read: ${this.text}`)
//         }
//     }

//     onPercChanged: {
//         proc.running = true;
//     }

//     // sets initial position
//     // probably not how its done
//     Timer {
//         running: true
//         repeat: true
//         interval: 16
//         onTriggered: {
//             if (root.width > 0) {
//                 knob.x = Math.floor((root.width - Config.slider.thickness) * root.perc / 100);
//                 stop();
//             }
//         }
//     }

//     CommonRect {
//         id: filled

//         color: Colors.current.accent

//         anchors.left: parent.left
//         anchors.right: knob.horizontalCenter

//         topRightRadius: 0
//         bottomRightRadius: 0
//     }

//     CommonRect {
//         id: bar

//         color: Colors.current.dull
//         anchors.right: parent.right
//         anchors.left: knob.horizontalCenter
//         topLeftRadius: 0
//         bottomLeftRadius: 0
//     }

//     CommonRect {
//         id: knob

//         color: Colors.current.border
//         implicitWidth: Config.slider.thickness

//         CustomText {
//             text: root.drag.active ? root.perc : root.text
//             font.family: !root.drag.active ? "Material Symbols Rounded" : "Monaspace Argon"
//             color: Colors.current.background

//             horizontalAlignment: Text.AlignHCenter
//             anchors.centerIn: parent
//         }

//         onXChanged: {
//             root.perc = Math.floor(x * 100 / (root.width - Config.slider.thickness));
//         }
//     }

// }
