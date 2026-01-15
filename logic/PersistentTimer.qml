pragma Singleton

import Quickshell
import QtQuick

Singleton {
    readonly property Timer timer: actual_timer
    property string comment: ""

    Timer {
        id: actual_timer

        property int minutes: 0
        property int seconds: 0

        running: false
        repeat: true

        onTriggered: {
            if (seconds <= 0 && minutes > 0) {
                minutes--;
                seconds = 59;
            }

            if (seconds <= 0 && minutes == 0) {
                timer.stop();
                if (Player.current && Player.current.isPlaying)
                    Player.current.stop();

                Quickshell.execDetached(["notify-send", "-a", "Fishy", "Timer", `Pomodoro timer went off!`]);
                return;
            }

            seconds--;
        }
    }
}
