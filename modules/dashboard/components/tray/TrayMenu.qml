import QtQuick
import Quickshell
import Quickshell.Services.SystemTray

import "../../../../widgets"
import "../../../../config"

// context menu loader
// i think these are made in modules/sidebar/components/ContextMenus.qml
// and wrapped in SlidingPanels or something similar
Item {
    id: root

    required property SystemTrayItem modelData
    required property bool shown // supposed to be used for cool animations

    implicitHeight: layout.implicitHeight
    implicitWidth: layout.implicitWidth

    visible: shown

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
    CustomRect {
        color: Colors.current.background
        anchors.fill: parent
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

                color: Colors.current.tertiary
                text: modelData.isSeparator ? "------" : modelData.text ?? "wtf"

                // HACK: maybe don't make that many, just one per menu?
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true

                    // mouse events
                    onPressed: event => {
                        entry.modelData.triggered();
                    }

                    onEntered: {
                        parent.color = Colors.current.primary;
                    }

                    onExited: {
                        parent.color = Colors.current.tertiary;
                    }
                }
            }
        }
    }
}
