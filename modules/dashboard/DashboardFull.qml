pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Notifications
import Quickshell.Widgets
import Quickshell.Io
import "../../widgets"
import "../../config"
import "../../logic"

import "../wallpapers"

import "components"

// this is supposed to be the panel at the top of the screen
// with a lot of controls.
Item {
    id: root

    required property MouseArea mous

    implicitWidth: 640 // TODO: probably reverse idk
    implicitHeight: 480
    // radius: Config.radius.normal
    // color: "transparent"

    Column {
        id: buttons

        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        anchors.margins: Config.spacing.small
        spacing: Config.spacing.small

        DashButton {
            id: button_home

            icon: "home"

            function onClick() {
                print("clicked home");
                menus.replaceCurrentItem(main_menu);
            }
        }
        DashButton {
            id: button_wallpapers

            icon: "photo_frame"

            function onClick() {
                menus.replaceCurrentItem(wallpapers);
            }
        }
        DashButton {
            id: button_player

            icon: "home"

            function onClick() {
            }
        }
    }

    ClippingRectangle {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: buttons.left
        anchors.margins: Config.spacing.small

        color: "transparent"
        radius: Config.radius.small

        StackView {
            id: menus

            initialItem: main_menu

            anchors.fill: parent
        }
    }

    Connections {
        target: root.mous

        function onPressed(event) {
            let pressed = buttons.children.find(c => Helper.checkInBounds(c, event, buttons.x, buttons.y));

            pressed?.onClick();
            if (!pressed)
                event.accepted = false;
        }
    }

    Component {
        id: main_menu
        MainMenu {
            mous: root.mous
        }
    }

    Component {
        id: wallpapers

        Wallpapers {
            mous: root.mous
        }
    }
}
