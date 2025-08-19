pragma ComponentBehavior: Bound

import QtQuick
import Quickshell

import "../../widgets"
import "../../logic"
import "../../config"

TripleToast {
    id: root

    readonly property var activeWS: Hypr.workspacesForScreen(screen).filter(w => w.active)[0]

    compactConponent: WorkspacesCompact {
        screen: root.screen
    }

    fullComponent: Item {}

    // override mouse behaviour
    ignoreClicks: true
    radius: Config.toast.size / 2

    Connections {
        target: root.tapHandler

        function onTapped() {
            let event = root.tapHandler.point.position;
            let layout = root.cLoader.item?.layout;

            let target = layout.children.find(c => {
                let top = c.y + layout.y - layout.spacing / 2;
                let bot = top + c.height + layout.spacing / 2;

                return top < event.y && event.y < bot;
            });

            target?.activate();
        }
    }

    // peek on ws change
    onActiveWSChanged: {
        root.peek();
    }
}
