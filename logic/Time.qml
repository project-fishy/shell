pragma Singleton

import Quickshell

// time wrapper
Singleton {
    readonly property string time: {
        Qt.formatDateTime(clock.date, "hh\nmm");
    }

    function format(format: string): string {
        return Qt.formatDateTime(clock.date, format);
    }

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
}
