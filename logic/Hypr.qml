pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland

Singleton {
    readonly property HyprlandMonitor currentMonitor: Hyprland.focusedMonitor
    readonly property HyprlandWorkspace currentWorkspace: Hyprland.focusedWorkspace

    function hasFullscreen(screen: ShellScreen): bool {
        return Hyprland.monitorFor(screen)?.activeWorkspace.hasFullscreen ?? false;
    }

    function windowsForWorkspace(workspace: HyprlandWorkspace): list<var> {
        return Hyprland.toplevels.values.filter(i => i.workspace === workspace);
    }

    function workspacesForScreen(screen: ShellScreen): list<var> {
        let monitor = Hyprland.monitorFor(screen);
        return Hyprland.workspaces.values.filter(w => w.monitor == monitor);
    }

    function monitorFor(screen: ShellScreen): HyprlandMonitor {
        return Hyprland.monitorFor(screen);
    }

    Connections {
        target: Hyprland

        function onRawEvent(event: HyprlandEvent): void {
            Hyprland.refreshMonitors();
            Hyprland.refreshWorkspaces();
            Hyprland.refreshToplevels();
        }
    }
}
