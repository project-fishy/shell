import Quickshell
import QtQuick
import Quickshell.Services.Mpris

import "../../widgets"
import "../../config"

Item {
    id: root

    anchors.fill: parent

    SlidingPanel {
        side: Config.panel.top

        child: CustomRect {
            implicitWidth: 640
            implicitHeight: 480
            color: Colors.current.background

            Item {
                id: margins
                anchors.fill: parent

                readonly property list<MprisPlayer> plrs: Mpris.players.values
                readonly property MprisPlayer plr: plrs.find(p => p.identity === "Spotify") ?? plrs[0]
                property bool playing: plr?.isPlaying ?? false

                anchors.topMargin: Config.border.thickness
                anchors.bottomMargin: Config.border.thickness
                anchors.leftMargin: Config.border.thickness
                anchors.rightMargin: Config.border.thickness

                onPlayingChanged: {
                    pl_img.opacity = playing ? 1 : 0;
                }

                AnimatedImage {
                    anchors.fill: parent
                    source: "root:/assets/eminem.gif"
                    // visible: !margins.playing
                }

                AnimatedImage {
                    id: pl_img

                    anchors.fill: parent
                    source: "root:/assets/eminem-swag.gif"
                    speed: 1
                    opacity: 0
                    // visible: margins.playing
                    Behavior on opacity {
                        NumberAnimation {
                            easing.type: Easing.Linear
                            duration: 200
                        }
                    }
                }
            }
        }
    }
}
