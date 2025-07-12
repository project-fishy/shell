import Quickshell
import Quickshell.Wayland

PanelWindow {
    required property string name
    color: "transparent"

    WlrLayershell.namespace: `fishy-${name}`
}
