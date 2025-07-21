import Quickshell
import QtQuick

import "../../widgets"
import "../../config"
import "../../logic"
import "../dashboard"
import "../sidebar/components/workspaces"

// contains all sliding panels
Item {
    id: root

    anchors.fill: parent
    required property ShellScreen screen

    // the dashboard
    TripleToast {
        anchors.top: parent.top
        collapseTo: Config.toast.top
        anchors.horizontalCenter: parent.horizontalCenter

        compactConponent: Item {
            implicitHeight: Config.toast.size
            implicitWidth: 200

            CustomText {
                text: Time.format("ddd, dd MMM hh:mm")
                color: Colors.current.on_background
                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
        }
        fullComponent: Dashboard {}
    }

    // the workspaces
    TripleToast {
        anchors.left: parent.left
        collapseTo: Config.toast.left
        anchors.verticalCenter: parent.verticalCenter

        compactConponent: Item {
            implicitWidth: Config.toast.size
            implicitHeight: ws.height
            Workspaces {
                id: ws
                screen: root.screen
            }
        }

        ignoreClicks: true
        fullComponent: Item {}
    }
}
