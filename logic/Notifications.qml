pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Notifications

Singleton {
    property alias tracked: server_.trackedNotifications
    property NotificationServer server: server_

    NotificationServer {
        id: server_

        keepOnReload: true

        imageSupported: true
        bodyHyperlinksSupported: true
        bodyImagesSupported: true
        bodyMarkupSupported: true
        actionsSupported: true
        inlineReplySupported: true
        persistenceSupported: true
        actionIconsSupported: true

        onNotification: notif => {
            notif.tracked = true;
        }
    }
}
