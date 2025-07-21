pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import "../config"

// jumping bars thing.
// FIXME: bars at 0 volume disappear?
Item {
    id: root

    property int bars: 5 // how many of bars there will be
    property list<int> volumes // cava values

    // stops cava to clear the output
    // HACK: theres better ways to clear probably
    // TODO: make it stop when audio is paused for some time
    onHeightChanged: {
        let running = height > 0;
        cava.running = running;
        if (!running)
            for (var i = 0; i < volumes.length; i++)
                volumes[i] = 0;
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

                anchors.bottom: parent.bottom
                implicitWidth: (root.width - row.spacing * (root.bars - 1)) / root.bars
                implicitHeight: modelData * root.height / 100

                color: Colors.current.primary
                radius: implicitWidth / 2

                Behavior on implicitHeight {
                    NumberAnimation {}
                }
            }
        }
    }

    // cava process
    Process {
        id: cava

        command: ["sh", "-c", `printf '[general]\nframerate=30\nbars=${root.bars}\nsleep_timer=3\n[output]\nchannels=mono\nmethod=raw\nraw_target=/dev/stdout\ndata_format=ascii\nascii_max_range=100' | cava -p /dev/stdin`]
        running: false

        stdout: StdioCollector {
            waitForEnd: false
            onDataChanged: {
                let splits = text.split("\n");
                let new_vals = splits[splits.length - 2];
                // print(splits[splits.length - 2]);
                volumes = new_vals.split(";").map(v => parseInt(v));
            }
        }
    }
}
