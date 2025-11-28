pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Widgets
import Quickshell.Io
import QtQuick
import QtQuick.Shapes

import "../../widgets"
import "../../config"
import "../../logic"

Item {
    id: root

    required property TripleToast toast

    readonly property bool isObserved: toast.state == Config.toast.state_shown
    readonly property Timer timer: PersistentTimer.timer

    // Timer {
    //     id: timer
    //
    //     property int minutes: 0
    //     property int seconds: 0
    //
    //     running: false
    //     repeat: true
    //
    //     onTriggered: {
    //         if (seconds <= 0 && minutes > 0) {
    //             minutes--;
    //             seconds = 59;
    //         }
    //
    //         if (seconds <= 0 && minutes == 0) {
    //             timer.stop();
    //             if (Player.current && Player.current.isPlaying)
    //                 Player.current.stop();
    //
    //             Quickshell.execDetached(["notify-send", "-a", "Fishy", "Timer", `Pomodoro timer went off!`]);
    //             return;
    //         }
    //
    //         seconds--;
    //     }
    // }

    Item {
        id: timer_container

        readonly property real cutout: height - 200
        readonly property real numBars: 50
        readonly property real size: height
        readonly property real barSize: 60

        width: height
        height: parent.height

        readonly property string color: Colors.current.primary

        CustomText {
            id: timer_text

            anchors.centerIn: parent
            // text: Time.format("hh:mm")
            color: Colors.current.on_background
            font.family: "Maple Mono CN"
            font.pixelSize: 70

            Binding on text {
                when: gif.state == "idle"
                value: Time.format("hh:mm")
            }

            Binding on text {
                when: gif.state != "idle"
                value: `${timer.minutes}:${timer.seconds}`
            }
        }

        AnimatedImage {
            source: "root:/assets/dancing-cat.gif"
            width: 200 * 0.75
            height: 94 * 0.75
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: timer_text.bottom

            playing: root.isObserved

            Behavior on opacity {
                NumberAnimation {
                    duration: 300
                }
            }

            opacity: Player.current?.isPlaying ? 0.7 : 0
            speed: vis.volumes.reduce((a, b) => a + b) / vis.volumes.length * 0.1 ?? 1
        }

        Visualizer {
            id: vis

            bars: timer_container.numBars
            framerate: 120

            active: root.isObserved
        }

        Shape {
            id: visualiser

            readonly property real centerX: width / 2
            readonly property real centerY: height / 2
            readonly property real innerX: timer_container.cutout / 2 + Config.spacing.small
            readonly property real innerY: timer_container.cutout / 2 + Config.spacing.small
            property color colour: timer_container.color

            anchors.fill: parent
            // anchors.margins: 20

            preferredRendererType: Shape.CurveRenderer
            data: visualiserBars.instances
        }

        Variants {
            id: visualiserBars

            model: Array.from({
                length: timer_container.numBars
            }, (_, i) => i)

            ShapePath {
                id: visualiserBar

                required property int modelData
                readonly property int value: Math.max(1, Math.min(100, vis.volumes[modelData]))

                readonly property real angle: modelData * 2 * Math.PI / timer_container.numBars
                readonly property real magnitude: value / 100 * timer_container.barSize
                readonly property real cos: Math.cos(angle)
                readonly property real sin: Math.sin(angle)

                capStyle: ShapePath.RoundCap
                // strokeWidth: 360 / timer_container.numBars - Config.spacing.small / 1000
                strokeWidth: 10
                strokeColor: timer_container.color

                startX: visualiser.centerX + (visualiser.innerX + strokeWidth / 2) * cos
                startY: visualiser.centerY + (visualiser.innerY + strokeWidth / 2) * sin

                PathLine {
                    x: visualiser.centerX + (visualiser.innerX + visualiserBar.strokeWidth / 2 + visualiserBar.magnitude) * visualiserBar.cos
                    y: visualiser.centerY + (visualiser.innerY + visualiserBar.strokeWidth / 2 + visualiserBar.magnitude) * visualiserBar.sin
                }

                // TODO: anim
                Behavior on strokeColor {
                    ColorAnimation {
                        duration: 10
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: [0.38, 1.21, 0.22, 1, 1, 1]
                    }
                }
            }
        }
    }

    TimerButton {
        id: startButton

        anchors.left: gif.left
        anchors.right: gif.right
        anchors.top: parent.top
        anchors.bottom: gif.top

        anchors.bottomMargin: Config.spacing.normal

        color: Colors.current.secondary
        textColor: Colors.current.on_secondary
        text: gif.state == "work" ? "Rest" : "Work"

        TapHandler {
            onTapped: {
                if (gif.state == "work") {
                    gif.state = "rest";
                    PersistentTimer.comment = "Rest";
                    timer.minutes = 5;
                    timer.seconds = 0;
                } else {
                    gif.state = "work";
                    PersistentTimer.comment = "Work";
                    timer.minutes = 25;
                    timer.seconds = 0;
                    if (Player.current && !Player.current?.isPlaying) {
                        Player.current.play();
                    }
                }
                timer.restart();
            }
        }
    }

    CatGif {
        id: gif

        height: width
        anchors.left: timer_container.right
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
    }

    TimerButton {
        id: stopButton

        anchors.left: gif.left
        anchors.right: gif.right
        anchors.bottom: parent.bottom
        anchors.top: gif.bottom

        anchors.topMargin: Config.spacing.normal

        color: Colors.current.tertiary
        textColor: Colors.current.on_tertiary
        text: "Stop"

        TapHandler {
            onTapped: gif.state = "idle"
        }
    }

    component TimerButton: CustomRect {
        required property string textColor
        required property string text

        radius: Config.radius.small
        opacity: 0.5

        CustomText {
            anchors.centerIn: parent
            color: parent.textColor
            text: parent.text
            font.family: "Maple Mono CN"
            font.pointSize: 30
            font.bold: true
        }
    }
    component CatGif: ClippingRectangle {
        id: cg

        property string state: "idle" // idle work rest
        property int randomness

        radius: Config.radius.small
        color: "transparent"

        AnimatedImage {
            anchors.fill: parent
            source: paths[randomness % paths.length] ?? ""

            playing: root.isObserved
        }

        property list<string> paths

        function regen() {
            scraper.exec(["sh", "-c", `ls assets/cats-${cg.state}`]);
            randomness = Math.floor(Math.random() * 100);
        }

        Component.onCompleted: {
            regen();

            // restore on recreation
            if (!root.timer.running)
                return;

            if (PersistentTimer.comment == "Work") {
                cg.state = "work";
            }

            if (PersistentTimer.comment == "Rest") {
                cg.state = "rest";
            }
        }

        onStateChanged: {
            print("collecting paths for " + state);
            paths = [];
            scraper.running = true;
            regen();
        }

        Process {
            id: scraper

            stdout: StdioCollector {
                onStreamFinished: paths = this.text.split("\n").filter(p => p != "").map(p => `root:/assets/cats-${cg.state}/` + p)
            }
        }

        TapHandler {
            onTapped: cg.randomness += 1
        }
    }
}
