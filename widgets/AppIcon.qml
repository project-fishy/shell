import QtQuick
import Quickshell

import "../config"

// uses mono font because non-mono have weird alignment
CustomText {
    required property string modelData
    property int size: 17

    font.family: "MesloLGL Nerd Font Mono"
    font.pointSize: size
    color: Colors.current.on_background

    Binding on anchors.horizontalCenter {
        when: parent
        value: parent.horizontalCenter
    }
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter

    text: {
        if (["Spotify", "spotify"].includes(modelData))
            return "";
        else if (["Code", "code"].includes(modelData))
            return "󰨞";
        else if (modelData == "kitty")
            return "";
        else if (modelData == "thunar")
            return "";
        else if (modelData == "steam")
            return "󰓓";
        else if (["zen", "vivaldi-stable"].includes(modelData))
            return "󰈹";
        else if (modelData == "vesktop")
            return "";
        else if (["org.telegram.desktop"].includes(modelData))
            return "";
        else if (["com-atlauncher-App"].includes(modelData))
            return "󰍳";
        else if (["TradingView"].includes(modelData))
            return "";
        else
            return "";
    }
}

// "MesloLGL Nerd Font"
