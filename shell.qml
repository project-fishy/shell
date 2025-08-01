//@ pragma Env QS_NO_RELOAD_POPUP=1

import Quickshell
import QtQuick
import "main_overlay"
import "modules/desktop"

ShellRoot {
    // wallpaper, widgets, anything else under windows
    Desktop {}

    // panels and other stuff above windows
    MainOverlay {}
}
