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

            // to-from  value
            // 100      x

            CustomText {
                text: root.pressed ? Math.floor(root.value * 100 / (root.to - root.from)) : root.text
                color: Colors.current.background

                font.family: !root.pressed ? "Material Symbols Rounded" : "Monaspace Argon"
                font.pointSize: root.pressed ? 10 : 20

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
        anchors.verticalCenter: parent.verticalCenter

        implicitHeight: root.height

        radius: Config.slider.thickness / 2
    }
}
