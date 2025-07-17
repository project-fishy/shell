import QtQuick
import Quickshell
import Quickshell.Services.SystemTray

import "../../../../widgets"

Item {
    id: root

    required property SystemTrayItem modelData
    required property bool shown

    implicitHeight: layout.implicitHeight
    implicitWidth: layout.implicitWidth

    visible: shown

    x: 200

    CustomRect {
        color: "#0f0"
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
                color: "#f00"

                MouseArea {
                    anchors.fill: parent
                    onPressed: event => {
                        entry.modelData.triggered();
                    }
                    hoverEnabled: true
                    onEntered: {
                        parent.color = "#00f";
                    }
                    onExited: {
                        parent.color = "#f00";
                    }
                }
            }
        }
    }
}
