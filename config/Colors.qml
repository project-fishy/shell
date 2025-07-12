pragma Singleton

import QtQuick
import Quickshell

Singleton {
    property Palette current: fishy

    Palette {
        id: fishy

        text: "#c5bf99"
        text_color: "#afc9d0"
        background: "#13181a"
        background_bright: ""
        border: "#afc9d0"
        accent: "#7aa5b1"
        red: "#dd6470"
    }

    component Palette: QtObject {
        required property string text
        required property string text_color
        required property string background
        required property string background_bright
        required property string border
        required property string accent
        required property string red
    }
}
