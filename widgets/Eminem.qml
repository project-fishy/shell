import QtQuick
import Quickshell

import "../logic"

// eminem gif
Item {
    id: margins

    property bool playing: Player.current?.isPlaying ?? false

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
