pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Notifications

Singleton {
    property alias tracked: server_.trackedNotifications
    property NotificationServer server: server_

    NotificationServer {
        id: server_

        // keepOnReload: false

        onNotification: notif => {
            notif.tracked = true;
        }
    }
}
