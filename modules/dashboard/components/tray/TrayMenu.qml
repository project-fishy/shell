import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray

import "../../../../widgets"
import "../../../../config"
import "../../../../logic"

// context menu loader
ClippingRectangle {
    id: root

    required property SystemTrayItem modelData
    required property bool shown // supposed to be used for cool animations

    readonly property MouseArea mouseArea: mous

    implicitHeight: shown || mous.containsMouse ? layout.implicitHeight : 0
    implicitWidth: shown || mous.containsMouse ? layout.implicitWidth : 0

    Behavior on implicitHeight {
        NumberAnimation {}
    }
    Behavior on implicitWidth {
        NumberAnimation {}
    }

    // place next to sidebar
    x: Config.bar.width

    // this loads menu items from modelData
    // items are children
    QsMenuOpener {
        id: opener

        Binding on menu {
            when: root.modelData.hasMenu
            value: root.modelData.menu
        }
    }

    // bg
    color: Colors.current.background

    MouseArea {
        id: mous

        anchors.fill: parent
        hoverEnabled: true

        // mouse events
        onPressed: event => {
            let entry = layout.children.find(c => Helper.checkInBounds(c, event, 0, 0));
            entry.modelData.triggered();
        }
    }

    // items
    Column {
        id: layout
        anchors.fill: parent

        Repeater {
            id: items

            model: opener.children.values

            // single entry
            // TODO: handle separators better
            CustomText {
                id: entry
                required property QsMenuEntry modelData

                color: Colors.current.on_background
                text: modelData.isSeparator ? "------" : modelData.text ?? "wtf"
            }
        }
    }
}
