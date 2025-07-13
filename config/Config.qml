pragma Singleton

import Quickshell
import QtQuick

Singleton {
    readonly property Borders border: Borders {}
    readonly property Bar bar: Bar {}

    component Borders: QtObject {
        property int thickness: 5
        property int radius: 10
    }

    component Bar: QtObject {
        property int width: 40
        property int workspaces: 5
        property int margins: 10

        readonly property Tray tray: Tray {}
    }

    component Tray: QtObject {
        property int iconSize: 20
        property int spacing: 5
    }
}
