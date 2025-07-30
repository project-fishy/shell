pragma ComponentBehavior: Bound

import QtQuick
import Quickshell

import "../../widgets"

TripleToast {
    id: root

    compactConponent: ControlsCompact {}
    fullComponent: ControlsFull {
        toast: root
    }
}
