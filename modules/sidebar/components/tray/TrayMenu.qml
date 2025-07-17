import QtQuick
import Quickshell
import Quickshell.Services.SystemTray

import "../../../../widgets"
import "../../../../config"

Item {
    id: root

    required property SystemTrayItem modelData
    required property bool shown

    implicitHeight: layout.implicitHeight
    implicitWidth: layout.implicitWidth

    visible: shown

    x: Config.bar.width

    CustomRect {
        color: Colors.current.background
        anchors.fill: parent
    }

    QsMenuOpener {
        id: opener

        Binding on menu {
            when: root.modelData.hasMenu
            value: root.modelData.menu
        }
    }

    Column {
        id: layout
        anchors.fill: parent
        Repeater {
            id: items

            model: opener.children.values

            CustomText {
                id: entry
                required property QsMenuEntry modelData

                text: modelData.isSeparator ? "------" : modelData.text ?? "wtf"
                color: Colors.current.text

                MouseArea {
                    anchors.fill: parent
                    onPressed: event => {
                        entry.modelData.triggered();
                    }
                    hoverEnabled: true
                    onEntered: {
                        parent.color = Colors.current.accent;
                    }
                    onExited: {
                        parent.color = Colors.current.text;
                    }
                }
            }
        }
    }
}
