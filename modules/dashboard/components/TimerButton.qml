import QtQuick
import Quickshell

import "../../../logic"
import "../../../config"
import "../../../widgets"

CustomRect {
    id: timerButton

    required property MouseArea mous
    required property int duration

    implicitWidth: 50
    implicitHeight: width

    radius: Config.radius.normal
    color: cooldownTimer.running ? Colors.current.secondary : Colors.current.primary

    function onClick() {
        if (cooldownTimer.running)
            cooldownTimer.stop();
        else
            cooldownTimer.restart();
    }

    CustomText {
        color: Colors.current.on_primary
        text: Helper.msToTime(Math.floor(cooldownTimer.interval / 1000))

        anchors.centerIn: parent
    }

    Connections {
        target: timerButton.mous

        function onPressed(event) {
            if (Helper.checkInMe(timerButton, event, mous))
                timerButton.onClick();
            else
                event.accepted = false;
        }
    }

    Timer {
        id: cooldownTimer

        interval: parent.duration
        repeat: false
        running: false

        onTriggered: {
            Quickshell.execDetached(["notify-send", `${Helper.msToTime(Math.floor(cooldownTimer.interval / 1000))} timer went off!)`]);
            // TODO: sound
        }
    }
}
