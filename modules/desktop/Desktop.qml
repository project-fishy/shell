import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Mpris

import QtQuick
import QtQuick.Effects
import QtMultimedia

import "../../widgets"
import "../../logic"
import "../../config"

Variants {
    model: Quickshell.screens

    Scope {

        CustomWindow {
            id: root
            aboveWindows: false

            anchors.bottom: true
            anchors.top: true
            anchors.left: true
            anchors.right: true

            WlrLayershell.exclusionMode: ExclusionMode.Ignore

            name: "widgets"

            Video {
                anchors.fill: parent
                source: "root:/assets/elden-cut.mp4"
                muted: true

                Component.onCompleted: {
                    play();
                }
            }

            Item {
                implicitHeight: 300
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter

                CustomText {
                    text: Time.format("hh:mm")
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom

                    font.pointSize: 100
                    font.family: "Monaspace Krypron"
                    color: Colors.current.background
                }
            }

            Item {
                // TODO: this is bad

                implicitHeight: 100
                implicitWidth: 1700

                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter

                CustomText {
                    readonly property list<MprisPlayer> plrs: Mpris.players.values
                    readonly property MprisPlayer plr: plrs.find(p => p.identity === "Spotify") ?? plrs[0]

                    text: plr.trackTitle + "\n" + plr.trackArtist || "ZXC Gnida"
                    color: Colors.current.text

                    font.pointSize: 15
                    font.family: "Monaspace Radon"

                    anchors.left: parent.left
                    anchors.top: parent.top
                }
            }
        }
    }
}
