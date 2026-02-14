pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Io

import "../config"
import "../logic"

// jumping bars thing.
// FIXME: bars at 0 volume disappear?
Item {
    id: root

    property int bars: 5 // how many of bars there will be
    property bool active: true
    property string color: Colors.current.primary
    property int framerate: 30

    property bool flipH: false
    property bool flipV: false

    readonly property list<Rectangle> rects: rectangles.children

    // the bars are stored in a row.
    Row {
        id: row

        anchors.fill: parent
        spacing: 3

        Repeater {
            id: rectangles

            model: root.flipH ? Cava.volumes_reverse : Cava.volumes

            anchors.fill: parent

            // single bar
            Rectangle {
                required property int modelData

                Binding on anchors.bottom {
                    value: rectangles.bottom
                    when: !root.flipV
                }

                Binding on anchors.top {
                    value: rectangles.top
                    when: root.flipV
                }

                implicitWidth: (root.width - row.spacing * (root.bars - 1)) / root.bars
                implicitHeight: modelData * root.height / 100

                color: root.color
                radius: implicitWidth / 2
            }
        }
    }
}
