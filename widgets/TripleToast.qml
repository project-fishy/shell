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
    property var expandOn: Qt.LeftButton
    property bool ignoreClicks: false

    readonly property bool onHorizEdges: collapseTo == Config.toast.top || collapseTo == Config.toast.bottom // on top/bottom?
    readonly property bool onCorner: secondAnchor != -1
    readonly property bool switchMouseAnchors: onHorizEdges ? height < compactLoader.height : width < compactLoader.width

    readonly property int marg: Config.toast.margins

    // I ASKED
    states: [
        State {
            // hidden
            name: Config.toast.state_hidden
            PropertyChanges {
                root.implicitHeight: root.onHorizEdges ? Config.toast.interactible_size : compactLoader.height + root.marg * 2
                root.implicitWidth: root.onHorizEdges ? compactLoader.width + root.marg * 2 : Config.toast.interactible_size
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

        anchors.fill: compactLoader
        Binding on anchors.fill {
            when: root.state == Config.toast.state_shown
            value: fullLoader
        }

        color: Colors.current.background
        radius: 10
    }

    ContentLoader {
        id: compactLoader
        anchors.margins: root.marg
        sourceComponent: root.compactConponent
    }

    ContentLoader {
        id: fullLoader
        visible: root.state == Config.toast.state_shown

        sourceComponent: root.fullComponent
    }

    MouseArea {
        id: mous
        hoverEnabled: true
        propagateComposedEvents: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        // wacky woohoo event magic (makes children clickable and all that)
        onEntered: root.state = Config.toast.state_peek
        onExited: root.state = Config.toast.state_hidden
        onPressed: event => {
            if (!root.ignoreClicks && event.button == root.expandOn)
                root.state = Config.toast.state_shown;
            event.accepted = false;
        }
        onReleased: event => {
            event.accepted = false;
        }
        onClicked: event => {
            event.accepted = false;
        }
        onPressAndHold: event => {
            event.accepted = false;
        }
        onPositionChanged: event => {
            event.accepted = false;
        }

        // wacky woohoo binding magic
        anchors.left: compactLoader.left
        Binding on anchors.left {
            when: root.collapseTo == Config.toast.left || root.secondAnchor == Config.toast.left || root.switchMouseAnchors && !root.onHorizEdges || root.state == Config.toast.state_shown
            value: root.left
            restoreMode: Binding.RestoreBindingOrValue
        }
        anchors.right: compactLoader.right
        Binding on anchors.right {
            when: root.collapseTo == Config.toast.right || root.secondAnchor == Config.toast.right || root.switchMouseAnchors && root.onHorizEdges || root.state == Config.toast.state_shown
            value: root.right
            restoreMode: Binding.RestoreBindingOrValue
        }
        anchors.top: compactLoader.top
        Binding on anchors.top {
            when: root.collapseTo == Config.toast.top || root.secondAnchor == Config.toast.top || root.switchMouseAnchors && !root.onHorizEdges || root.state == Config.toast.state_shown
            value: root.top
            restoreMode: Binding.RestoreBindingOrValue
        }
        anchors.bottom: compactLoader.bottom
        Binding on anchors.bottom {
            when: root.collapseTo == Config.toast.bottom || root.secondAnchor == Config.toast.bottom || root.switchMouseAnchors && root.onHorizEdges || root.state == Config.toast.state_shown
            value: root.bottom
            restoreMode: Binding.RestoreBindingOrValue
        }
    }

    component ContentLoader: Loader {
        active: true

        Binding on anchors.top {
            when: root.collapseTo == Config.toast.bottom || root.secondAnchor == Config.toast.bottom
            value: parent.top
        }
        Binding on anchors.bottom {
            when: root.collapseTo == Config.toast.top || root.secondAnchor == Config.toast.top
            value: parent.bottom
        }
        Binding on anchors.left {
            when: root.collapseTo == Config.toast.right || root.secondAnchor == Config.toast.right
            value: parent.left
        }
        Binding on anchors.right {
            when: root.collapseTo == Config.toast.left || root.secondAnchor == Config.toast.left
            value: parent.right
        }

        Behavior on opacity {
            NumberAnimation {}
        }

        Binding on anchors.horizontalCenter {
            value: root.horizontalCenter
            when: root.onHorizEdges && !root.onCorner
        }

        Binding on anchors.verticalCenter {
            value: root.verticalCenter
            when: !root.onHorizEdges && !root.onCorner
        }
    }

    Behavior on implicitHeight {
        Anim {}
    }

    Behavior on implicitWidth {
        Anim {}
    }

    component Anim: NumberAnimation {
        easing.type: Easing.BezierSpline
        duration: Animations.duration.normal
        easing.bezierCurve: [0.38, 1.21, 0.22, 1, 1, 1]
    }
}
