pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls

import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Notifications

import "../../widgets"
import "../../logic"
import "../../config"

import "components"

ClippingRectangle {
    id: root

    required property TripleToast toast

    readonly property Timer timer: flick_timer // expose for peeks

    property Notification notification

    implicitHeight: flick_timer.running ? stackview.currentItem.desiredHeight : Config.toast.size
    implicitWidth: 200

    color: "transparent"

    StackView {
        id: stackview

        anchors.fill: parent

        initialItem: Clock {}

        Timer {
            id: flick_timer
            interval: 3000

            onTriggered: {
                while (stackview.depth > 1)
                    stackview.pop();
            }
        }

        // show notification
        Connections {
            target: Notifications.server

            function onNotification(n) {
                root.notification = n;
                stackview.push(compactNotif);
                flick_timer.restart();
            }
        }

        // for destruction
        Component {
            id: compactNotif

            CustomNotification {
                modelData: root.notification
            }
        }
    }
}
