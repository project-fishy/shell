pragma Singleton

import QtQuick
import Quickshell

// numbers regarding animations
Singleton {
    readonly property Duration duration: Duration {}

    component Duration: QtObject {
        readonly property int normal: 400
    }
}
