pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

// volume wrapper
// TODO: the whole pipewire bs with input/output selection and volume per
Singleton {
    property PwNode output: Pipewire.defaultAudioSink
    property real current: output?.audio?.volume ?? 0 // get from here

    function set(value: real): int { // set here
        if (output?.ready && output?.audio) {
            // apparently muting isnt the same as setting vol to 0
            // TODO: expand on this
            output.audio.muted = false;
            output.audio.volume = value;
        }
    }

    // this makes quickshell update values
    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }
}
