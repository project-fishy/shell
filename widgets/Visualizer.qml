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

    property list<int> volumes // cava values
    property bool mirror: false

    readonly property list<Rectangle> rects: rectangles.children

    // on creation set running to active
    Component.onCompleted: {
        cava.running = root.active;
    }

    onActiveChanged: {
        cava.running = active;
    }

    // the bars are stored in a row.
    Row {
        id: row

        anchors.fill: parent
        spacing: 3

        Repeater {
            id: rectangles

            model: root.volumes

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

    // cava process
    Process {
        id: cava

        command: ["sh", "-c", `printf '[general]\nframerate=${root.framerate}\nbars=${root.bars}\nsleep_timer=3\n[output]\nchannels=mono\nmethod=raw\nraw_target=/dev/stdout\ndata_format=ascii\nascii_max_range=100' | cava -p /dev/stdin`]
        running: false

        stdout: SplitParser {
            onRead: text => {
                let vols = text.split(";").map(v => Helper.clamp(parseInt(v), 1, 100));
                root.volumes = root.flipH ? vols.reverse() : vols;
            }
        }

        stderr: SplitParser {
            onRead: text => cava.running = false
        }

        // on crash restart
        onRunningChanged: {
            if (root.active && !running) {
                running = true;
            }

            if (!running)
                root.volumes = [0];
        }
    }
}
