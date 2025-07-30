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

// import "./components"

// this is supposed to be the panel at the top of the screen
// with a lot of controls.
ClippingRectangle {
    id: root

    required property MouseArea mous

    implicitWidth: 640 // TODO: probably reverse idk
    implicitHeight: 480
    radius: Config.radius.normal
    color: "transparent"

    Column {
        id: buttons

        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        anchors.margins: Config.spacing.small
        spacing: Config.spacing.small

        DashButton {
            id: button_home

            text: "Home"
            icon: "home"

            function onClick() {
                print("clicked home");
                menus.replaceCurrentItem(main_menu);
            }
        }
        DashButton {
            id: button_wallpapers

            text: "Wallpapers"
            icon: "photo_frame"

            function onClick() {
                menus.replaceCurrentItem(wallpapers);
            }
        }
        DashButton {
            id: button_player

            text: "Music"
            icon: "home"

            function onClick() {
            }
        }
    }

    StackView {
        id: menus

        initialItem: main_menu
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: buttons.left
        anchors.margins: Config.spacing.small
    }

    Connections {
        target: root.mous

        function onPressed(event) {
            let pressed = buttons.children.find(c => Helper.checkInBounds(c, event, buttons.x, buttons.y));

            pressed?.onClick();
        }
    }

    component DashButton: CustomRect {
        id: dash_button

        required property string icon
        required property string text

        implicitWidth: 100
        implicitHeight: 50
        radius: Config.radius.small

        color: Colors.current.primary

        TextIcon {
            id: db_icon
            text: dash_button.icon
            color: Colors.current.on_primary
            anchors.verticalCenter: parent.verticalCenter
            x: y
        }
        CustomText {
            id: db_text
            text: dash_button.text
            color: Colors.current.on_primary
            anchors.verticalCenter: parent.verticalCenter
            x: db_icon.x * 2 + db_icon.width
        }
    }

    Component {
        id: main_menu
        Item {
            // anchors.fill: parent

            ClippingRectangle {
                id: notifications

                // property NotificationServer server: NotificationServer {}

                implicitWidth: parent.width / 2
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: parent.left

                color: Colors.current.surface_container
                radius: Config.radius.small

                Flickable {
                    anchors.fill: parent
                    contentHeight: notif_layout.height
                    contentWidth: notif_layout.width

                    Column {
                        id: notif_layout

                        Repeater {
                            model: Notifications.tracked

                            CustomNotification {
                                implicitWidth: notifications.width
                                implicitHeight: 100
                            }
                        }
                    }
                }
            }

            CustomRect {
                id: weather

                anchors.left: notifications.right
                anchors.right: parent.right
                anchors.top: parent.top
                implicitHeight: 50
                anchors.leftMargin: Config.spacing.small

                color: Colors.current.primary

                TextIcon {
                    text: "partly_cloudy_day"
                    color: Colors.current.on_primary
                }
            }
        }
    }

    Component {
        id: wallpapers

        Item {
            // anchors.fill: parent

            MatugenWrapper {
                id: scheme_generator

                path: "/home/desant/Downloads/image.png"

                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: parent.left

                CustomRect {
                    anchors.fill: parent
                    color: "#0f0"
                }

                implicitWidth: childrenRect.width

                Column {
                    Repeater {
                        model: scheme_generator.schemes
                        SchemeRect {
                            implicitHeight: scheme_generator.height / scheme_generator.schemes.length
                            // implicitHeight: 59
                        }
                    }
                }
            }
        }
    }

    component SchemeRect: CustomRect {
        id: scheme_rect
        required property MatugenWrapper.Scheme modelData

        // implicitHeight: 50
        implicitWidth: childrenRect.width + Config.spacing.small * 2
        color: modelData.background
        radius: Config.radius.small

        Row {
            anchors.verticalCenter: parent.verticalCenter
            x: Config.spacing.small
            // implicitHeight: parent.height = Config.spacing.smaller * 2

            Dot {
                color: scheme_rect.modelData.primary
                implicitHeight: scheme_rect.height - Config.spacing.small * 2
            }

            Dot {
                color: scheme_rect.modelData.secondary
            }
        }
    }

    component Dot: CustomRect {
        // implicitHeight: parent.height - Config.spacing.small * 2
        implicitWidth: implicitHeight
        radius: height / 2
    }
    // Item {
    //     anchors.fill: parent
    //     anchors.margins: 10
    //     // bars
    //     Visualizer {
    //         id: bars
    //         anchors.top: parent.top
    //         anchors.bottom: slider_volume.top
    //         implicitWidth: 100
    //         visible: parent.visible
    //     }

    //     // eminem gif
    //     Eminem {
    //         id: eminem
    //         anchors.top: parent.top
    //         anchors.right: parent.right
    //         anchors.left: bars.right
    //         anchors.bottom: slider_volume.top
    //     }

    //     // volume
    //     CustomSlider {
    //         id: slider_volume

    //         text: "brand_awareness"

    //         from: 0
    //         to: 1

    //         value: Volume.current
    //         onMoved: Volume.set(value)

    //         anchors.left: parent.left
    //         anchors.right: parent.right
    //         anchors.bottom: slider_brightness.top
    //     }

    //     // brightness
    //     CustomSlider {
    //         id: slider_brightness

    //         text: "brightness_5"
    //         value: Brightness.current

    //         onValueChanged: {
    //             Brightness.set(value);
    //         }

    //         onPressedChanged: {
    //             Brightness.suppressUpdates = pressed;
    //         }

    //         anchors.left: parent.left
    //         anchors.right: parent.right
    //         anchors.bottom: parent.bottom
    //     }
    // }
}
