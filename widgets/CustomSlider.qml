import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Io

import "../widgets"
import "../config"

// wrapper for Slider, adds animations and whatnot
Slider {
    id: root

    required property string text // the icon on the knob

    from: 0 // this is gonna be 0-100, if you want
    to: 100 // anything other than that - handle outside

    implicitHeight: Config.slider.thickness

    // override elements (https://doc.qt.io/qt-6/qml-qtquick-controls-slider-members.html)
    // the knob you drag
    handle: CustomRect {
        id: knob

        implicitWidth: root.height
        implicitHeight: root.height

        x: root.visualPosition * (root.availableWidth - width)

        color: Colors.current.primary

        radius: root.height / 2

        CustomText {
            text: root.pressed ? Math.floor(root.value * 100 / (root.to - root.from)) : root.text
            color: Colors.current.on_primary

            font.family: !root.pressed ? "Material Symbols Rounded" : "Monaspace Argon"
            font.pointSize: root.pressed ? 10 : 20

            horizontalAlignment: Text.AlignHCenter
            anchors.centerIn: parent
        }
    }

    // bar thingy
    background: Item {
        // left part
        CommonRect {
            id: filled

            color: Colors.current.primary_fixed_dim

            anchors.left: parent.left

            implicitWidth: knob.x + root.height / 2 // can't anchor :(

            topRightRadius: 0
            bottomRightRadius: 0
        }

        // right part
        CommonRect {
            id: bar

            color: Colors.current.inverse_on_surface

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
