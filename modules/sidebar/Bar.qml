import Quickshell
import QtQuick
import "../../config"
import "components"
import "components/workspaces"
import "components/tray"

Item {
    id: root
    required property var screen

    anchors.top: parent.top
    anchors.left: parent.left
    anchors.bottom: parent.bottom

    implicitWidth: Config.bar.width

    Rectangle {
        anchors.fill: parent

        color: Colors.current.background

        Workspaces {
            id: ws
            anchors.top: parent.top
            anchors.topMargin: Config.bar.margins
        }

        // TEST {
        //     anchors.top: ws.bottom
        //     anchors.bottom: clock.top
        //     anchors.horizontalCenter: parent.horizontalCenter
        //     implicitWidth: root.implicitWidth
        // }

        Tray {
            anchors.bottom: clock.top
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Clock {
            id: clock

            anchors.bottom: battery.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: Config.bar.margins
        }

        Battery {
            id: battery
            anchors.bottom: power.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: Config.bar.margins
        }

        Power {
            id: power
            anchors.bottom: parent.bottom
        }
    }

    component TEST: Item {
        id: root

        Rectangle {
            id: rect

            anchors.fill: parent
            color: Colors.current.accent
        }

        MouseArea {
            id: mous
            anchors.fill: parent

            onPressed: event => {
                rect.color = Colors.current.text;
            }

            onEntered: event => {
                rect.color = Colors.current.accent;
            }
        }
    }
}
