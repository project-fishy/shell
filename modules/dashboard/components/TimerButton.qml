import QtQuick
import QtMultimedia
import Quickshell

import "../../../logic"
import "../../../config"
import "../../../widgets"

CustomRect {
    id: root

    required property int duration
    required property SoundEffect sound

    implicitWidth: 50
    implicitHeight: width

    radius: Config.radius.normal
    color: cooldownTimer.running ? Colors.current.secondary : Colors.current.primary

    TapHandler {

        onTapped: {
            if (cooldownTimer.running)
                cooldownTimer.stop();
            else
                cooldownTimer.restart();
        }
    }

    CustomText {
        color: Colors.current.on_primary
        text: Helper.msToTime(Math.floor(cooldownTimer.interval / 1000))

        anchors.centerIn: parent
    }

    Timer {
        id: cooldownTimer

        interval: parent.duration
        repeat: false
        running: false

        onTriggered: {
            Quickshell.execDetached(["notify-send", "-a", "Fishy", "Timer", `${Helper.msToTime(Math.floor(cooldownTimer.interval / 1000))} timer went off!)`]);
            root.sound.play();
        }
    }
}
