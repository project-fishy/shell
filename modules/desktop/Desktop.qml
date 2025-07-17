import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Mpris

import QtQuick
import QtQuick.Effects
import QtMultimedia

import "../../widgets"
import "../../logic"
import "../../config"

// this is a background window that holds
// the wallpaper and widgets (if any)
Variants {
    model: Quickshell.screens

    Scope {
        id: scope
        required property ShellScreen modelData

        CustomWindow {
            id: root
            aboveWindows: false
            screen: scope.modelData

            // fill the whole screen
            anchors.bottom: true
            anchors.top: true
            anchors.left: true
            anchors.right: true

            // don't reserve space
            WlrLayershell.exclusionMode: ExclusionMode.Ignore

            name: "widgets" // idk

            // animated wallpaper
            Loader {
                active: Charge.charging && !Hypr.hasFullscreen(scope.modelData)
                anchors.fill: parent

                sourceComponent: VideoBG {}
            }

            // clock
            // HACK: make better align
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

            // now playing
            // HACK: this is bad
            Item {

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

    component VideoBG: Video {
        id: vid

        anchors.fill: parent

        source: "root:/assets/elden-cut.mp4"
        loops: MediaPlayer.Infinite
        muted: true

        Component.onCompleted: {
            play();
        }
    }
}
