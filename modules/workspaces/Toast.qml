import QtQuick
import Quickshell

import "../../widgets"
import "../../config"
import "../../logic"

TripleToast {
    id: workspaces

    compactConponent: WorkspacesCompact {
        screen: root.screen
    }

    fullComponent: Item {}

    // override mouse behaviour
    ignoreClicks: true

    Connections {
        target: workspaces.mouseArea

        function onPressed(event) {
            let layout = workspaces.cLoader.item?.layout;

            let target = layout.children.find(c => {
                let top = c.y + layout.y - layout.spacing / 2;
                let bot = top + c.height + layout.spacing / 2;

                return top < event.y && event.y < bot;
            });

            target?.activate();
        }
    }

    // peek on ws change
    Connections {
        target: Hypr
        function onCurrentWorkspaceChanged() {
            if (Hypr.currentWorkspace.monitor === Hypr.monitorFor(root.screen))
                workspaces.peek();
        }
    }
}
