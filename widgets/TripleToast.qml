pragma ComponentBehavior: Bound

import QtQuick
import Quickshell

import "../config"
import "../logic"

Item { // container for margins, placement
    id: root

    required property Component compactConponent
    required property Component fullComponent

    required property int collapseTo
    property int secondAnchor: -1
    readonly property bool onHorizEdges: collapseTo == Config.toast.top || collapseTo == Config.toast.bottom // on top/bottom?
    readonly property bool onCorner: secondAnchor != -1

    readonly property int marg: Config.toast.margins

    // FIXME: ONLY GOD KNOWS IF THIS CAN BE DONE WITH ANCHORS
    states: [
        State {
            // hidden
            name: Config.toast.state_hidden
            PropertyChanges {
                root.implicitWidth: root.onHorizEdges ? compactLoader.width + root.marg * 2 : Config.toast.interactible_size
                root.implicitHeight: root.onHorizEdges ? Config.toast.interactible_size : compactLoader.height + root.marg * 2

                mous.implicitWidth: compactLoader.width + (root.onCorner ? root.marg : 0)
                mous.implicitHeight: root.onHorizEdges ? Config.toast.interactible_size : compactLoader.height + (root.onCorner ? root.marg : 0)
                fullLoader.opacity: 0
                compactLoader.opacity: 1
            }
        },
        State {
            // peek
            name: Config.toast.state_peek
            PropertyChanges {
                root.implicitWidth: compactLoader.width + root.marg * 2
                root.implicitHeight: compactLoader.height + root.marg * 2
                mous.implicitWidth: root.onHorizEdges ? compactLoader.width + (root.onCorner ? root.marg : 0) : Helper.clamp(root.width, 0, compactLoader.width + root.marg)
                mous.implicitHeight: root.onHorizEdges ? Helper.clamp(root.height, 0, compactLoader.height + root.marg) : compactLoader.height + (root.onCorner ? root.marg : 0)
                fullLoader.opacity: 0
                compactLoader.opacity: 1
            }
        },
        State {
            // show
            name: Config.toast.state_shown
            PropertyChanges {
                root.implicitWidth: fullLoader.width
                root.implicitHeight: fullLoader.height
                mous.implicitWidth: root.width
                mous.implicitHeight: root.height
                compactLoader.opacity: 0
                fullLoader.opacity: 1
            }
        }
    ]

    state: Config.toast.state_hidden

    CustomRect {
        id: background

        anchors.fill: parent
        anchors.margins: root.marg
        color: "#00f"

        ContentLoader {
            id: compactLoader

            sourceComponent: root.compactConponent
        }

        ContentLoader {
            id: fullLoader

            sourceComponent: root.fullComponent
        }
    }

    MouseArea {
        id: mous
        hoverEnabled: true

        onEntered: root.state = Config.toast.state_peek
        onExited: root.state = Config.toast.state_hidden
        onClicked: root.state = Config.toast.state_shown

        CustomRect {
            anchors.fill: parent
            // color: "#0f0"
        }

        Binding on anchors.left {
            when: root.collapseTo == Config.toast.left || root.secondAnchor == Config.toast.left
            value: root.left
        }
        Binding on anchors.right {
            when: root.collapseTo == Config.toast.right || root.secondAnchor == Config.toast.right
            value: root.right
        }
        Binding on anchors.top {
            when: root.collapseTo == Config.toast.top || root.secondAnchor == Config.toast.top
            value: root.top
        }
        Binding on anchors.bottom {
            when: root.collapseTo == Config.toast.bottom || root.secondAnchor == Config.toast.bottom
            value: root.bottom
        }
    }

    component ContentLoader: Loader {
        active: true

        Binding on anchors.top {
            when: root.collapseTo == Config.toast.bottom
            value: parent.top
        }
        Binding on anchors.bottom {
            when: root.collapseTo == Config.toast.top
            value: parent.bottom
        }
        Binding on anchors.left {
            when: root.collapseTo == Config.toast.right
            value: parent.left
        }
        Binding on anchors.right {
            when: root.collapseTo == Config.toast.left
            value: parent.right
        }

        Behavior on opacity {
            NumberAnimation {}
        }
    }

    Behavior on implicitHeight {
        NumberAnimation {}
    }

    Behavior on implicitWidth {
        NumberAnimation {}
    }
}
