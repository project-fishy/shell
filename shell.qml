//@ pragma Env QS_NO_RELOAD_POPUP=1

import Quickshell
import QtQuick
import "modules/main_overlay"
import "modules/desktop"

ShellRoot {
    // this is the entire thing pretty much
    Desktop {}
    MainOverlay {}
}
