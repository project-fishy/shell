pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Singleton {
    property PwNode output: Pipewire.defaultAudioSink
    property real current: output?.audio?.volume ?? 0

    function set(value: real): int {
        if (output?.ready && output?.audio) {
            // apparently muting isnt the same as setting vol to 0
            // TODO: expand on this
            output.audio.muted = false;
            output.audio.volume = value;
        }
    }

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }
}
