import QtQuick
import Quickshell.Widgets
// import QtMultimedia

import "../../../logic"
import "../../../widgets"
import "../../../config"
import "../../player"

Item {
    id: root

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

                        TapHandler {
                            onTapped: parent.modelData.dismiss()
                        }
                    }
                }
            }
        }
    }

    // weather
    CustomRect {
        id: weather

        implicitHeight: 50
        implicitWidth: parent.width / 4

        anchors.left: notifications.right
        anchors.leftMargin: Config.spacing.small
        anchors.top: parent.top

        radius: Config.radius.normal

        color: Colors.current.primary

        TapHandler {
            onTapped: Weather.refreshWeather()
        }

        TextIcon {
            id: wRefresh
            text: "autorenew"
            color: Colors.current.on_primary

            anchors.right: parent.right
            anchors.top: parent.top

            visible: Weather.loading
        }

        TextIcon {
            id: wIcon
            text: Weather.icon
            color: Colors.current.on_primary

            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 5

            font.pointSize: 30
        }

        CustomText {
            id: wTemp

            color: Colors.current.on_primary
            text: Weather.tempC

            anchors.left: wIcon.right
            anchors.leftMargin: 10
            anchors.top: wIcon.top
            anchors.topMargin: 5

            font.pointSize: 15
            // font.family: "Maple Mono NL CN"
            font.bold: true
        }

        CustomText {
            id: wDesc

            color: Colors.current.on_primary
            text: Weather.description

            // anchors.bottom: wIcon.bottom
            // anchors.bottomMargin: 10
            anchors.left: wIcon.right
            anchors.leftMargin: 10

            anchors.top: wTemp.bottom
            anchors.topMargin: -2

            font.family: "Maple Mono NL CN"
            font.bold: true
            font.italic: true
        }
    }

    CustomRect {
        id: placeholder

        implicitHeight: weather.height

        anchors.left: weather.right
        anchors.right: parent.right

        color: Colors.current.surface_container
        radius: weather.radius
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
    // Row {
    //     id: timers
    //
    //     anchors.top: slider_brightness.bottom
    //     anchors.left: notifications.right
    //
    //     anchors.margins: Config.spacing.small
    //     spacing: Config.spacing.small
    //
    //     SoundEffect {
    //         id: timerSound
    //
    //         // source: "root:/assets/timer.wav"
    //     }
    //
    //     TimerButton {
    //         duration: 5 * 60 * 1000
    //         sound: timerSound
    //     }
    //
    //     TimerButton {
    //         duration: 10 * 60 * 1000
    //         sound: timerSound
    //     }
    //
    //     TimerButton {
    //         duration: 15 * 60 * 1000
    //         sound: timerSound
    //     }
    //
    //     TimerButton {
    //         duration: 20 * 60 * 1000
    //         sound: timerSound
    //     }
    //
    //     TimerButton {
    //         duration: 25 * 60 * 1000
    //         sound: timerSound
    //     }
    //     TimerButton {
    //         duration: 30 * 60 * 1000
    //         sound: timerSound
    //     }
    // }

    Calendar {
        id: calendar

        anchors.top: slider_brightness.bottom
        anchors.left: notifications.right
        anchors.right: parent.right
    }

    MiniPlayer {
        id: player

        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.left: notifications.right
        anchors.top: calendar.bottom
    }
}
