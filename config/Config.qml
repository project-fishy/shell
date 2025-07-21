pragma Singleton

import Quickshell
import QtQuick

// numbers regarding element placement
Singleton {
    readonly property Borders border: Borders {}
    readonly property Bar bar: Bar {}
    readonly property Panel panel: Panel {}
    readonly property Slider slider: Slider {}
    readonly property Toasts toast: Toasts {}

    component Toasts: QtObject {
        property int size: 35
        property int interactible_size: 5
        property int margins: 3

        readonly property string state_hidden: "hidden"
        readonly property string state_peek: "peek"
        readonly property string state_shown: "shown"

        readonly property int right: 0
        readonly property int left: 1
        readonly property int top: 2
        readonly property int bottom: 3
    }

    component Borders: QtObject {
        property int thickness: 5
        property int radius: 10
    }

    component Slider: QtObject {
        readonly property int thickness: 25
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

    component Panel: QtObject {
        readonly property int right: 0
        readonly property int left: 1
        readonly property int top: 2
        readonly property int bottom: 3
        readonly property int outline: 1
    }
}
