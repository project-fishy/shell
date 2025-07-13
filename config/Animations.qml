pragma Singleton

import QtQuick
import Quickshell

Singleton {
    readonly property Duration duration: Duration {}

    component Duration: QtObject {
        readonly property int normal: 400
    }
}
