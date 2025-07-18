pragma Singleton

import QtQuick
import Quickshell

// color palettes
// TODO: dynamic load from autogenerated
Singleton {
    property Palette current: fishy

    Palette {
        id: fishy

        text: "#c5bf99"
        text_color: "#afc9d0"
        background: "#13181a"
        background_bright: "#192022"
        border: "#afc9d0"
        accent: "#7aa5b1"
        dull: "#575f62"
        red: "#dd6470"
    }

    component Palette: QtObject {
        required property string text
        required property string text_color
        required property string background
        required property string background_bright
        required property string border
        required property string accent
        required property string dull
        required property string red
    }
}
