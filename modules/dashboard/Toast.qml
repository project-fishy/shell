pragma ComponentBehavior: Bound

import QtQuick
import Quickshell

import "../../widgets"

TripleToast {
    id: root

    compactConponent: DashboardCompact {
        toast: root
    }

    fullComponent: DashboardFull {}

    Component.onCompleted: {
        print(root.cLoader.item);
        print(root.cLoader.item?.timer);
    }

    Connections {
        target: root.cLoader.item?.timer
        enabled: root.cLoader.item ?? false

        function onRunningChanged() {
            if (root.cLoader.item?.timer.running)
                root.peek(root.cLoader.item.timer.interval + 300);
        }
    }
}
