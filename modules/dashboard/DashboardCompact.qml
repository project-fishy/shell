pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls

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
    readonly property bool clockVisible: {
        let ws = Hypr.workspacesForScreen(screen).find(w => w.active);
        let windows = Hypr.windowsForWorkspace(ws).map(w => w.lastIpcObject);

        // return windows.count() > 0;
        return false;
    }

    property Notification notification

    implicitHeight: flick_timer.running ? stackview.currentItem.desiredHeight : Config.toast.size
    implicitWidth: root.toast.overshadowed ? 200 : 250

    color: "transparent"

    StackView {
        id: stackview

        anchors.fill: parent

        initialItem: Clock {
            showWeather: !root.toast.overshadowed
        }

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

        // Connections {
        //     target: root
        //
        //     function onClockVisibleChanged() {
        //         if (!root.clockVisible) {
        //             stackview.replace()
        //         }
        //     }
        // }

        // for destruction
        Component {
            id: compactNotif

            CustomNotification {
                modelData: root.notification
            }
        }

        pushEnter: Transition {
            ParallelAnimation {
                PropertyAnimation {
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: 100
                }

                PropertyAnimation {
                    property: "y"
                    from: Config.toast.size
                    to: 0
                    duration: 100
                }
            }
        }

        pushExit: Transition {
            ParallelAnimation {
                PropertyAnimation {
                    property: "opacity"
                    from: 1
                    to: 0
                    duration: 100
                }

                PropertyAnimation {
                    property: "y"
                    from: 0
                    to: -1 * Config.toast.size
                    duration: 100
                }
            }
        }

        popEnter: Transition {
            ParallelAnimation {
                PropertyAnimation {
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: 100
                }

                PropertyAnimation {
                    property: "y"
                    from: -1 * Config.toast.size
                    to: 0
                    duration: 100
                }
            }
        }

        popExit: Transition {
            ParallelAnimation {
                PropertyAnimation {
                    property: "opacity"
                    from: 1
                    to: 0
                    duration: 100
                }

                PropertyAnimation {
                    property: "y"
                    from: 0
                    to: Config.toast.size
                    duration: 100
                }
            }
        }
    }
}
