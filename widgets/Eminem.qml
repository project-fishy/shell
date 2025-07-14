import QtQuick
import Quickshell
import Quickshell.Services.Mpris

Item {
    id: margins

    readonly property list<MprisPlayer> plrs: Mpris.players.values
    readonly property MprisPlayer plr: plrs.find(p => p.identity === "Spotify") ?? plrs[0]
    property bool playing: plrs.some(p => p.isPlaying) ?? false

    onPlayingChanged: {
        pl_img.opacity = playing ? 1 : 0;
    }

    AnimatedImage {
        anchors.fill: parent
        source: "root:/assets/eminem.gif"
    }

    AnimatedImage {
        id: pl_img

        anchors.fill: parent
        source: "root:/assets/eminem-swag.gif"
        speed: 1
        opacity: 0

        Behavior on opacity {
            NumberAnimation {
                easing.type: Easing.Linear
                duration: 200
            }
        }
    }
}
