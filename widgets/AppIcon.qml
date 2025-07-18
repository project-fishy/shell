import QtQuick
import Quickshell

import "../config"

// uses mono font because non-mono have weird alignment
CustomText {
    required property string modelData
    property int size: 17

    font.family: "MesloLGL Nerd Font Mono"
    font.pointSize: size
    color: Colors.current.text

    anchors.horizontalCenter: parent.horizontalCenter
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter

    text: {
        if (modelData == "Spotify")
            return "";
        else if (modelData == "Code")
            return "󰨞";
        else if (modelData == "kitty")
            return "";
        else if (modelData == "thunar")
            return "";
        else if (modelData == "steam")
            return "󰓓";
        else if (modelData == "zen")
            return "󰈹";
        else if (modelData == "vesktop")
            return "";
        else
            return "";
    }
}

// "MesloLGL Nerd Font"
