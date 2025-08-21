import QtQuick

import "../../widgets"

Item {
    Visualizer {
        mirror: true

        anchors.top: parent.top
        anchors.bottom: controls_container.top
        anchors.left: parent.left
        anchors.right: eminem.left
    }

    Eminem {
        id: eminem

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.bottom: controls_container.top

        implicitWidth: parent.width / 3 * 2
    }

    Visualizer {
        mirror: false

        anchors.top: parent.top
        anchors.bottom: controls_container.top
        anchors.left: eminem.right
        anchors.right: parent.right
    }

    Item {
        id: controls_container

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        height: 150
    }
}
