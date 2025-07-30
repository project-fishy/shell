pragma ComponentBehavior: Bound

import QtQuick
import Quickshell

import "../../widgets"

TripleToast {
    id: root

    compactConponent: DashboardCompact {
        toast: root
    }

    fullComponent: DashboardFull {
        mous: root.mouseArea
    }

    Component.onCompleted: {
        print(root.cLoader.item);
        print(root.cLoader.item?.timer);
    }

    Connections {
        target: root.cLoader.item?.timer

        function onRunningChanged() {
            if (root.cLoader.item?.timer.running)
                root.peek(root.cLoader.item.timer.interval + 300);
        }
    }
}
