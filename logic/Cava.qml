pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    property int bars: 15 // how many of bars there will be
    property bool active: true
    property int framerate: 30

    property bool flipH: false
    property bool flipV: false

    property list<int> volumes // cava values

    onVolumesChanged: {
        print(volumes);
    }

    // on creation set running to active
    Component.onCompleted: {
        cava.running = root.active;
    }

    onActiveChanged: {
        cava.running = active;
    }

    // cava process
    Process {
        id: cava

        command: ["sh", "-c", `printf '[general]\nframerate=${root.framerate}\nbars=${root.bars}\nsleep_timer=3\n[output]\nchannels=mono\nmethod=raw\nraw_target=/dev/stdout\ndata_format=ascii\nascii_max_range=100' | cava -p /dev/stdin`]
        running: false

        stdout: SplitParser {
            onRead: text => {
                root.volumes = text.split(";").map(v => Helper.clamp(parseInt(v), 1, 100));
            // root.volumes = root.flipH ? vols.reverse() : vols;
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
