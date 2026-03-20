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
import "../player"
import "../pomodoro"

import "../wallpapers"

import "components"

// this is supposed to be the panel at the top of the screen
// with a lot of controls.
Item {
    id: root

    required property TripleToast toast

    implicitWidth: 740
    implicitHeight: 480

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

            tapHandler.onTapped: {
                print("clicked home");
                menus.replaceCurrentItem(main_menu);
            }
        }
        DashButton {
            id: button_wallpapers

            icon: "photo_frame"

            tapHandler.onTapped: {
                menus.replaceCurrentItem(wallpapers);
            }
        }
        DashButton {
            id: button_player

            icon: "music_note"

            tapHandler.onTapped: {
                menus.replaceCurrentItem(player);
            }
        }
        DashButton {
            id: button_pomodoro

            icon: "timer"

            tapHandler.onTapped: {
                menus.replaceCurrentItem(pomodoro);
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

    Component {
        id: main_menu

        MainMenu {}
    }

    Component {
        id: wallpapers

        Wallpapers {}
    }

    Component {
        id: player

        PlayerFull {}
    }

    Component {
        id: pomodoro

        Pomodoro {
            toast: root.toast
        }
    }
}
