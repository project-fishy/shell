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
    property list<int> volumes_reverse

    // on creation set running to active
    Component.onCompleted: {
        cava.running = root.active;
        restartFixTimer.start();
    }

    onActiveChanged: {
        cava.running = active;
        restartFixTimer.start();
    }

    Timer {
        id: restartFixTimer

        interval: 10000

        running: false

        onTriggered: {
            if (root.active && root.volumes.length < root.bars) {
                cava.running = false;
                cava.running = true;
                restart();
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
                let volumes = text.split(";").map(v => Helper.clamp(parseInt(v), 1, 100));
                root.volumes = volumes;
                root.volumes_reverse = volumes.reverse();
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
