pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

import "../config"

Item {
    id: root

    property int bars: 5
    property list<int> volumes

    onVolumesChanged: {
        for (const v of volumes) {}
    }

    Row {
        id: row
        anchors.fill: parent
        spacing: 3

        Repeater {
            id: rectangles

            model: root.volumes

            anchors.fill: parent

            Rectangle {
                required property int modelData

                anchors.bottom: parent.bottom
                implicitWidth: (root.width - row.spacing * (root.bars - 1)) / root.bars
                implicitHeight: modelData * root.height / 100

                color: Colors.current.accent
                radius: implicitWidth / 2

                Behavior on implicitHeight {
                    NumberAnimation {}
                }
            }
        }
    }

    Process {
        id: cava

        command: ["sh", "-c", `printf '[general]\nframerate=30\nbars=${root.bars}\nsleep_timer=3\n[output]\nchannels=mono\nmethod=raw\nraw_target=/dev/stdout\ndata_format=ascii\nascii_max_range=100' | cava -p /dev/stdin`]
        running: true

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
