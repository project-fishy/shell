pragma Singleton

import Quickshell
import QtQuick

Singleton {
    readonly property Borders border: Borders {}

    component Borders: QtObject {
        property int thickness: 5
        property int radius: 10
    }

    component Bar: QtObject {
        property int width: 30
    }
}
