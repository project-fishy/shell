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

    function set(value: int): void { // set here
        Quickshell.execDetached(["brightnessctl", "s", value + "%", "-q"]);
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

        command: ["brightnessctl", "g", "-m"]

        stdout: StdioCollector {
            onStreamFinished: {
                root.current = parseInt(this.text);
            }
        }
    }
}
