pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.UPower

Singleton {
    readonly property UPowerDevice battery: UPower.displayDevice
    readonly property bool charging: !UPower.onBattery

    // current percentage (who needs decimals anyways)
    readonly property int current: Math.floor(battery.percentage * 100)

    // time left until charged/dead
    readonly property string timeLeft: {
        let total = charging ? battery.timeToFull : battery.timeToEmpty;

        let seconds = total % 60;
        let minutes = (total - seconds) / 60 % 60;
        let hours = ((total - seconds) / 60 - minutes) / 60;

        return (hours > 0 ? `${hours}h ` : "") + `${minutes}m`;
    }

    // draw/charge rate
    // FIXME: im not sure it works as intended
    readonly property string draw: {
        let cr = Math.floor(battery.changeRate);
        if (cr > 0)
            return `Charging: ${cr}W`;
        else
            return `Draw: ${cr * -1}W`;
    }

    // for use with TextIcon
    readonly property string icon_text: {
        if (charging) {
            if (current == 100)
                return "battery full";
            else if (current >= 90)
                return "battery_charging_90";
            else if (current >= 80)
                return "battery_charging_80";
            else if (current >= 60)
                return "battery_charging_60";
            else if (current >= 45)
                return "battery_charging_50";
            else if (current >= 30)
                return "battery_charging_30";
            else
                return "battery_charging_20";
        } else {
            if (current <= 5)
                return "battery_alert";
            else if (current <= 10)
                return "battery_0_bar";
            else if (current <= 20)
                return "battery_1_bar";
            else if (current <= 30)
                return "battery_2_bar";
            else if (current <= 40)
                return "battery_3_bar";
            else if (current <= 50)
                return "battery_4_bar";
            else if (current <= 75)
                return "battery_5_bar";
            else if (current <= 90)
                return "battery_6_bar";
            else
                return "battery_full";
        }
    }
}
