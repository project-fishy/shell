//@ pragma Env QS_NO_RELOAD_POPUP=1

import Quickshell
import QtQuick
import "modules/main_overlay"

ShellRoot {
    // this is the entire thing pretty much
    MainOverlay {}

    // PanelWindow {
    //     screen: Quickshell.screens[0]
    //     anchors.top: true
    //     anchors.bottom: true
    //     // anchors.right: true
    //     anchors.left: true

    //     // WlrLayershell.exclusionMode: ExclusionMode.Ignore

    //     aboveWindows: false

    //     color: "#333333"
    //     implicitWidth: 300

    //     Text {
    //         text: "as1213d"
    //         color: "red"
    //     }
    // }
}
