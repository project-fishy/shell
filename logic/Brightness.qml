pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

// brightness wrapper
// TODO: second monitor thing?
Singleton {
    id: root

    property HyprlandMonitor activeMonitor: Hyprland.monitors?.values.find(m => m.active)
    property int current // get from here

    function set(value: int): void { // set here
        Quickshell.execDetached(["brightnessctl", "s", value + "%", "-q"]);
    }

    Process {
        id: change_checker

        running: true
        command: ["udevadm", "monitor", "--property", "--subsystem-match=backlight"]

        onStarted: {
            print("watching brightness");
        }

        stdout: StdioCollector {
            onTextChanged: {
                refresher.running = true;
            }

            waitForEnd: false
        }
    }

    Process {
        id: refresher

        running: true

        command: ["brightnessctl", "g", "-m"]

        stdout: StdioCollector {
            onStreamFinished: {
                root.current = parseInt(this.text);
            }
        }
    }
}
