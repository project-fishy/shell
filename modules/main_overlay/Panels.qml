import Quickshell
import QtQuick

import "../../widgets"
import "../../config"
import "../../logic"
import "../dashboard"

// contains all sliding panels
Item {
    id: root

    anchors.fill: parent

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
}
