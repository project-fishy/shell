import QtQuick
import Quickshell
import Quickshell.Services.UPower

import "../../../widgets"
import "../../../config"

// battery icon thing
// TODO: move logic
Column {
    id: root

    // charge text
    TextIcon {
        text: !UPower.onBattery ? "battery_charging_full" : "battery_full"
        color: Colors.current.text_color
    }

    // icon
    CustomText {
        text: {
            const perc = Math.floor(UPower.displayDevice.percentage * 100);
            // return UPower.onBattery ? perc : "idk";
            return perc + "%";
        }
        font.pointSize: 9
        anchors.horizontalCenter: root.horizontalCenter
    }
}
