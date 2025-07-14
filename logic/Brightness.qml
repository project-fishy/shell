pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

Singleton {
    id: root

    property HyprlandMonitor activeMonitor: Hyprland.monitors?.values.find(m => m.active)
    property int current

    function set(value: int): void {
        Quickshell.execDetached(["brightnessctl", "s", value + "%"]);
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
