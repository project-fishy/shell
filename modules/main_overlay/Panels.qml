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
                AnimatedImage {
                    anchors.fill: parent
                    source: "root:/assets/eminem.gif"
                    visible: !margins.playing
                }

                AnimatedImage {
                    anchors.fill: parent
                    source: "root:/assets/eminem-swag.gif"
                    visible: margins.playing
                }
            }
        }
    }
}
