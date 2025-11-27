pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

// brightness wrapper
// TODO: second monitor thing?
Singleton {
    id: root

    property int current // get from here
    property bool suppressUpdates: false // fixes slider jitter
    property string device: "amdgpu_bl1" // TODO: load from config
    readonly property int exponent: 2

    readonly property list<string> commandStart: device ? ["brightnessctl", "-d", root.device] : ["brightnessctl"]

    function set(value: int): void { // set here
        Quickshell.execDetached(Helper.flatten([root.commandStart, [`-e${root.exponent}`, "s", value + "%", "-q"]]));
    }

    // watches for brightness changes
    Process {
        id: change_checker

        running: !root.suppressUpdates
        command: ["udevadm", "monitor", "--property", "--subsystem-match=backlight"]

        stdout: StdioCollector {
            onTextChanged: {
                refresher.running = true;
            }

            waitForEnd: false // get continuous output
        }
    }

    // sets current value
    Process {
        id: refresher

        running: true // run once to set initial value

        command: Helper.flatten([root.commandStart, ["i", "-m", `-e${root.exponent}`]])

        stdout: StdioCollector {
            onStreamFinished: {
                root.current = this.text.split(",")[3].replace(/%/, "");
            }
        }
    }
}
