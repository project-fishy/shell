pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Services.Mpris

import "../config"

Singleton {
    id: root

    property var hasAny: players.length > 0
    property MprisPlayer current

    readonly property list<MWrapper> players: variants.instances

    readonly property string now_playing: current ? `${current?.trackTitle}` + (current.trackTitle.length > 20 ? "" : ` - ${current?.trackArtist}`) : "nothing"
    readonly property string color: current?.isPlaying ? Colors.current.secondary : Colors.current.on_background

    Variants {
        id: variants

        model: Mpris.players.values

        MWrapper {}
    }

    // FIXME: does not detect on startup

    component MWrapper: QtObject {
        required property MprisPlayer modelData
        readonly property bool isPlaying: modelData.isPlaying

        onIsPlayingChanged: {
            if (!root.current?.isPlaying && isPlaying) {
                root.current = modelData;
            }
        }
    }
}
