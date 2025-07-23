pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Mpris

import "../config"

Singleton {
    property var hasAny: all.length > 0
    property MprisPlayer current: hasAny ? all.find(p => p.identity == "Spotify") ?? all[0] : null
    property var all: Mpris.players.values

    readonly property string now_playing: `${current?.trackTitle} - ${current?.trackArtist}` ?? "nothing"
    readonly property string color: current?.isPlaying ? Colors.current.secondary : Colors.current.on_background
}
