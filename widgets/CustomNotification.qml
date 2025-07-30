pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Services.Notifications

import "../config"

CustomRect {
    id: root

    color: Colors.current.surface
    radius: Config.radius.noramal
    implicitHeight: childrenRect.height

    required property Notification modelData

    Column {

        CustomText {
            color: Colors.current.on_surface_variant
            text: root.modelData.appName
            wrapMode: Text.Wrap
        }

        CustomText {
            color: Colors.current.on_surface
            wrapMode: Text.Wrap
            width: root.width
            text: root.modelData.body
        }
    }
}
