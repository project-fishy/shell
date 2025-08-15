import QtQuick
import Quickshell.Widgets

import "../../../logic"
import "../../../widgets"
import "../../../config"

Item {
    id: root

    required property MouseArea mous

    // notif column
    ClippingRectangle {
        id: notifications

        implicitWidth: parent.width / 2
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left

        color: Colors.current.surface_container
        radius: Config.radius.small

        // make it scroll
        Flickable {
            id: flickable
            anchors.fill: parent
            contentHeight: notif_layout.height
            contentWidth: notif_layout.width
            flickableDirection: Flickable.VerticalFlick

            // generate
            Column {
                id: notif_layout

                spacing: Config.spacing.small

                Repeater {
                    model: Notifications.tracked

                    // TODO: add margins somehow
                    CustomNotification {
                        implicitWidth: notifications.width
                    }
                }
            }

            // handle clicks
            Connections {
                target: root.mous

                function onPressed(event) {
                    let selected = notif_layout.children.find(c => c instanceof CustomNotification && Helper.checkInMe(c, event, root.mous));
                    if (selected)
                        selected.modelData.dismiss();
                }
            }
        }
    }

    // weather
    CustomRect {
        id: weather

        implicitHeight: 50
        anchors.leftMargin: Config.spacing.small

        anchors.left: notifications.right
        anchors.right: parent.right
        anchors.top: parent.top

        color: Colors.current.primary

        TextIcon {
            text: "partly_cloudy_day"
            color: Colors.current.on_primary
        }
    }

    // volume
    CustomSlider {
        id: slider_volume

        text: "brand_awareness"

        from: 0
        to: 1

        value: Volume.current
        onMoved: Volume.set(value)

        anchors.left: notifications.right
        anchors.top: weather.bottom
        anchors.right: parent.right

        anchors.margins: 5
    }

    // brightness
    CustomSlider {
        id: slider_brightness

        text: "brightness_5"
        value: Brightness.current

        onValueChanged: {
            Brightness.set(value);
        }

        onPressedChanged: {
            Brightness.suppressUpdates = pressed;
        }

        anchors.left: notifications.right
        anchors.top: slider_volume.bottom
        anchors.right: parent.right

        anchors.margins: 5
    }

    // TODO: spread them somehow
    Row {
        id: timers

        anchors.top: slider_brightness.bottom
        anchors.left: notifications.right

        anchors.margins: Config.spacing.small
        spacing: Config.spacing.small

        TimerButton {
            duration: 5 * 60 * 1000
            mous: root.mous
        }

        TimerButton {
            duration: 10 * 60 * 1000
            mous: root.mous
        }

        TimerButton {
            duration: 15 * 60 * 1000
            mous: root.mous
        }

        TimerButton {
            duration: 20 * 60 * 1000
            mous: root.mous
        }

        TimerButton {
            duration: 25 * 60 * 1000
            mous: root.mous
        }
        TimerButton {
            duration: 30 * 60 * 1000
            mous: root.mous
        }
    }
}
